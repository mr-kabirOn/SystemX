package com.systemx.app.background

import android.content.Context
import androidx.work.Constraints
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import com.systemx.app.R
import com.systemx.app.platform.AlertRules
import java.util.concurrent.TimeUnit

/** Takes a history sample every 15 minutes and refreshes the widgets. */
class SampleWorker(ctx: Context, params: WorkerParameters) : Worker(ctx, params) {
    override fun doWork(): Result {
        val r = Readings.read(applicationContext)
        Sampler.onReading(applicationContext, r)
        WidgetUpdater.update(applicationContext, r)
        // Re-arm the charger watch in case its chain was interrupted.
        Scheduler.armChargeWatch(applicationContext, null, ExistingWorkPolicy.KEEP)
        return Result.success()
    }
}

/**
 * Starts when a charger is connected (WorkManager charging constraint),
 * then checks every two minutes until it is unplugged. This is what makes
 * the charge alarm and charging sessions timely without a running service.
 */
class ChargeWatchWorker(ctx: Context, params: WorkerParameters) : Worker(ctx, params) {
    override fun doWork(): Result {
        val ctx = applicationContext
        val r = Readings.read(ctx)
        Sampler.onReading(ctx, r)
        if (r.pluggedIn) {
            val c = ConfigStore.load(ctx)
            val close = c.chargeAlarm && r.level >= c.chargeLimit - 3 && r.level < c.chargeLimit
            Scheduler.armChargeWatch(ctx, if (close) 60_000L else 120_000L, ExistingWorkPolicy.APPEND_OR_REPLACE)
        } else {
            Scheduler.armChargeWatch(ctx, null, ExistingWorkPolicy.APPEND_OR_REPLACE)
        }
        return Result.success()
    }
}

/** Weekly battery summary from the stored history. */
class WeeklySummaryWorker(ctx: Context, params: WorkerParameters) : Worker(ctx, params) {
    override fun doWork(): Result {
        val ctx = applicationContext
        val c = ConfigStore.load(ctx)
        if (!c.weeklySummary) return Result.success()
        val since = System.currentTimeMillis() - 7 * AlertRules.DAY
        val db = HistoryDb.get(ctx)
        val samples = db.samples(since)
        val charges = db.sessions(100).count { it.startMs >= since }
        if (samples.isEmpty()) return Result.success()
        val maxTemp = samples.maxOf { it.tempC }
        val minLevel = samples.minOf { it.level }
        Notifications.post(
            ctx, Notifications.ID_WEEKLY, Notifications.SUMMARY,
            ctx.getString(R.string.n_weekly_title),
            ctx.getString(R.string.n_weekly_text, charges, AlertRules.temp(maxTemp, c.fahrenheit), minLevel.toInt()),
            "/monitor",
        )
        return Result.success()
    }
}

/** Daily check: reminds once a month when the last checkup is a month old. */
class CheckupReminderWorker(ctx: Context, params: WorkerParameters) : Worker(ctx, params) {
    override fun doWork(): Result {
        val ctx = applicationContext
        val c = ConfigStore.load(ctx)
        val now = System.currentTimeMillis()
        val month = 30 * AlertRules.DAY
        if (c.checkupReminder && c.lastCheckupMs > 0 && now - c.lastCheckupMs >= month &&
            AlertRules.cooldownOver(ConfigStore.mark(ctx, "reminder"), now, month)
        ) {
            ConfigStore.setMark(ctx, "reminder", now)
            Notifications.post(
                ctx, Notifications.ID_REMINDER, Notifications.SUMMARY,
                ctx.getString(R.string.n_reminder_title),
                ctx.getString(R.string.n_reminder_text), "/checkup",
            )
        }
        return Result.success()
    }
}

/** Makes the background work and the live status service match the config. */
internal object Scheduler {
    fun apply(context: Context) {
        val ctx = context.applicationContext
        val c = ConfigStore.load(ctx)
        val wm = WorkManager.getInstance(ctx)
        Notifications.ensureChannels(ctx)

        wm.enqueueUniquePeriodicWork(
            "sample", ExistingPeriodicWorkPolicy.KEEP,
            PeriodicWorkRequestBuilder<SampleWorker>(15, TimeUnit.MINUTES).build(),
        )
        armChargeWatch(ctx, null, ExistingWorkPolicy.KEEP)

        if (c.weeklySummary) {
            wm.enqueueUniquePeriodicWork(
                "weekly", ExistingPeriodicWorkPolicy.KEEP,
                PeriodicWorkRequestBuilder<WeeklySummaryWorker>(7, TimeUnit.DAYS)
                    .setInitialDelay(7, TimeUnit.DAYS).build(),
            )
        } else {
            wm.cancelUniqueWork("weekly")
        }
        if (c.checkupReminder) {
            wm.enqueueUniquePeriodicWork(
                "reminder", ExistingPeriodicWorkPolicy.KEEP,
                PeriodicWorkRequestBuilder<CheckupReminderWorker>(1, TimeUnit.DAYS).build(),
            )
        } else {
            wm.cancelUniqueWork("reminder")
        }

        if (c.liveStatus) LiveStatusService.start(ctx) else LiveStatusService.stop(ctx)
    }

    /** [delayMs] null waits for a charger to be connected. */
    fun armChargeWatch(ctx: Context, delayMs: Long?, policy: ExistingWorkPolicy) {
        val b = OneTimeWorkRequestBuilder<ChargeWatchWorker>()
        if (delayMs == null) {
            b.setConstraints(Constraints.Builder().setRequiresCharging(true).build())
        } else {
            b.setInitialDelay(delayMs, TimeUnit.MILLISECONDS)
        }
        WorkManager.getInstance(ctx).enqueueUniqueWork("charge_watch", policy, b.build())
    }
}
