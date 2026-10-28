package com.systemx.app.background

import android.content.Context
import com.systemx.app.R
import com.systemx.app.platform.AlertRules
import com.systemx.app.platform.SessionRules
import kotlin.math.roundToInt

/**
 * Handles every background reading: records history (at most every five
 * minutes), keeps the charging session up to date and sends the alerts
 * the user turned on, each once per charge or after a cooldown.
 */
internal object Sampler {
    private const val SAMPLE_EVERY = 5 * 60_000L

    /** An open session is written at most this often, unless its level changes. */
    private const val SESSION_WRITE_EVERY = 60_000L

    // Kept in memory between readings in one process; a new process falls
    // back to what the database holds.
    private var lastWriteMs = 0L
    private var lastPlugged = 0
    private var lastPluggedMs = 0L

    @Synchronized
    fun onReading(ctx: Context, r: Reading) {
        val db = HistoryDb.get(ctx)
        if (r.timeMs - db.lastSampleTime() >= SAMPLE_EVERY) db.addSample(r)

        var open = db.openSessionInfo()
        if (open != null && r.pluggedIn && SessionRules.isNewCharge(
                open.lastLevel, r.level, lastPlugged, r.plugged,
                if (lastPluggedMs > 0) r.timeMs - lastPluggedMs else null,
            )) {
            // Unplugged and plugged in again between two readings: end the
            // first charge where it was last seen and start a new one.
            db.closeSession(open.id, if (lastPluggedMs > open.start) lastPluggedMs else r.timeMs)
            db.pruneSessions()
            open = null
        }
        var sessionStart = open?.start ?: 0L
        if (r.pluggedIn) {
            if (open == null) {
                db.startSession(r)
                sessionStart = r.timeMs
                lastWriteMs = r.timeMs
                ConfigStore.setMark(ctx, "low", 0) // low battery may alert again after this charge
            } else if (r.level != open.lastLevel || r.timeMs - lastWriteMs >= SESSION_WRITE_EVERY) {
                db.updateSession(open.id, r, close = false)
                lastWriteMs = r.timeMs
            }
            lastPlugged = r.plugged
            lastPluggedMs = r.timeMs
        } else {
            if (open != null) {
                db.updateSession(open.id, r, close = true)
                db.pruneSessions()
            }
            lastPlugged = 0
        }
        alerts(ctx, r, sessionStart)
    }

    private fun alerts(ctx: Context, r: Reading, sessionStart: Long) {
        val c = ConfigStore.load(ctx)
        val now = r.timeMs
        val temp = AlertRules.temp(r.tempC, c.fahrenheit)

        if (c.chargeAlarm && sessionStart > 0 &&
            AlertRules.chargeLimitReached(r.level, c.chargeLimit.toInt(), r.pluggedIn) &&
            ConfigStore.mark(ctx, "limit") != sessionStart
        ) {
            ConfigStore.setMark(ctx, "limit", sessionStart)
            Notifications.post(
                ctx, Notifications.ID_CHARGE_LIMIT, Notifications.BATTERY,
                ctx.getString(R.string.n_limit_title, r.level),
                ctx.getString(R.string.n_limit_text), "/live/battery",
            )
        }

        if (c.chargingDone && sessionStart > 0 && r.full && ConfigStore.mark(ctx, "full") != sessionStart) {
            ConfigStore.setMark(ctx, "full", sessionStart)
            val s = HistoryDb.get(ctx).sessions(1).firstOrNull()
            val minutes = ((now - sessionStart) / 60_000L).toInt()
            val text = if (s != null) {
                ctx.getString(R.string.n_full_text, s.startLevel.toInt(), r.level, minutes / 60, minutes % 60) +
                    (s.peakMa?.let { " · " + ctx.getString(R.string.n_peak, it.toInt()) } ?: "")
            } else ""
            Notifications.post(
                ctx, Notifications.ID_FULL, Notifications.BATTERY,
                ctx.getString(R.string.n_full_title), text, "/monitor",
            )
        }

        if (c.batteryLow && AlertRules.batteryLow(r.level, c.lowLevel.toInt(), r.pluggedIn) &&
            ConfigStore.mark(ctx, "low") == 0L
        ) {
            ConfigStore.setMark(ctx, "low", now)
            Notifications.post(
                ctx, Notifications.ID_LOW, Notifications.BATTERY,
                ctx.getString(R.string.n_low_title, r.level),
                ctx.getString(R.string.n_low_text), "/live/battery",
            )
        }

        if (c.batteryHot && AlertRules.batteryHot(r.tempC, c.hotC.toInt()) &&
            AlertRules.cooldownOver(ConfigStore.mark(ctx, "hot"), now, 2 * AlertRules.HOUR)
        ) {
            ConfigStore.setMark(ctx, "hot", now)
            Notifications.post(
                ctx, Notifications.ID_HOT, Notifications.BATTERY,
                ctx.getString(R.string.n_hot_title, temp),
                ctx.getString(R.string.n_hot_text), "/live/thermal",
            )
        }

        if (c.storageFull && AlertRules.storageFull(r.storageTotal, r.storageFree, c.storagePercent.toInt()) &&
            AlertRules.cooldownOver(ConfigStore.mark(ctx, "storage"), now, AlertRules.DAY)
        ) {
            ConfigStore.setMark(ctx, "storage", now)
            val used = ((r.storageTotal - r.storageFree) * 100.0 / r.storageTotal).roundToInt()
            Notifications.post(
                ctx, Notifications.ID_STORAGE, Notifications.STORAGE,
                ctx.getString(R.string.n_storage_title, used),
                ctx.getString(R.string.n_storage_text), "/device/storage",
            )
        }
    }
}
