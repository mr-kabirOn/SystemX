package com.systemx.app.background

import android.content.Context
import android.content.SharedPreferences
import com.systemx.app.platform.BackgroundConfig

/** Background settings and alert bookkeeping, readable without Flutter running. */
internal object ConfigStore {
    private const val FILE = "systemx_background"

    fun prefs(ctx: Context): SharedPreferences =
        ctx.applicationContext.getSharedPreferences(FILE, Context.MODE_PRIVATE)

    fun load(ctx: Context): BackgroundConfig {
        val p = prefs(ctx)
        return BackgroundConfig(
            liveStatus = p.getBoolean("liveStatus", false),
            statusIcon = p.getString("statusIcon", null) ?: "battery_level",
            chargeAlarm = p.getBoolean("chargeAlarm", false),
            chargeLimit = p.getLong("chargeLimit", 80),
            batteryLow = p.getBoolean("batteryLow", false),
            lowLevel = p.getLong("lowLevel", 15),
            batteryHot = p.getBoolean("batteryHot", false),
            hotC = p.getLong("hotC", 45),
            chargingDone = p.getBoolean("chargingDone", false),
            storageFull = p.getBoolean("storageFull", false),
            storagePercent = p.getLong("storagePercent", 90),
            weeklySummary = p.getBoolean("weeklySummary", false),
            checkupReminder = p.getBoolean("checkupReminder", false),
            fahrenheit = p.getBoolean("fahrenheit", false),
            lastCheckupMs = p.getLong("lastCheckupMs", 0),
        )
    }

    fun save(ctx: Context, c: BackgroundConfig) {
        prefs(ctx).edit()
            .putBoolean("liveStatus", c.liveStatus)
            .putString("statusIcon", c.statusIcon)
            .putBoolean("chargeAlarm", c.chargeAlarm)
            .putLong("chargeLimit", c.chargeLimit)
            .putBoolean("batteryLow", c.batteryLow)
            .putLong("lowLevel", c.lowLevel)
            .putBoolean("batteryHot", c.batteryHot)
            .putLong("hotC", c.hotC)
            .putBoolean("chargingDone", c.chargingDone)
            .putBoolean("storageFull", c.storageFull)
            .putLong("storagePercent", c.storagePercent)
            .putBoolean("weeklySummary", c.weeklySummary)
            .putBoolean("checkupReminder", c.checkupReminder)
            .putBoolean("fahrenheit", c.fahrenheit)
            .putLong("lastCheckupMs", c.lastCheckupMs)
            .apply()
    }

    fun setLiveStatus(ctx: Context, on: Boolean) {
        prefs(ctx).edit().putBoolean("liveStatus", on).apply()
    }

    /** Alert bookkeeping: when something was last sent, or a session id. */
    fun mark(ctx: Context, key: String): Long = prefs(ctx).getLong("mark_$key", 0)

    fun setMark(ctx: Context, key: String, value: Long) {
        prefs(ctx).edit().putLong("mark_$key", value).apply()
    }
}
