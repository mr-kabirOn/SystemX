package com.systemx.app.background

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.TrafficStats
import android.os.BatteryManager
import android.os.Environment
import android.os.PowerManager
import android.os.StatFs
import com.systemx.app.platform.SysParsers

/** One reading of what the background features watch. */
internal data class Reading(
    val timeMs: Long,
    val level: Int,
    val status: Int,
    val plugged: Int,
    val tempC: Double,
    val voltageMv: Int,
    val currentMa: Long?,
    val memTotal: Long,
    val memAvailable: Long,
    val storageTotal: Long,
    val storageFree: Long,
    val rxBytes: Long,
    val txBytes: Long,
    /** BatteryManager.BATTERY_HEALTH_* value, -1 if unknown. */
    val health: Int = -1,
    /** Charge left in mAh from the battery's own counter, if it has one. */
    val chargeCounterMah: Long? = null,
    /** Whether the screen was on when read. */
    val screenOn: Boolean = false,
) {
    val pluggedIn get() = plugged != 0
    val full get() = status == BatteryManager.BATTERY_STATUS_FULL || (pluggedIn && level >= 100)
    val memUsed get() = if (memTotal > 0) 1.0 - memAvailable.toDouble() / memTotal else 0.0
}

internal object Readings {
    fun read(context: Context): Reading {
        val ctx = context.applicationContext
        val intent = ctx.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = intent?.getIntExtra(BatteryManager.EXTRA_SCALE, 100) ?: 100
        val status = intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
        val charging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
            status == BatteryManager.BATTERY_STATUS_FULL
        val bm = ctx.getSystemService(BatteryManager::class.java)
        val current = try {
            bm?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)
                ?.takeIf { it != Int.MIN_VALUE && it != 0 }
        } catch (_: Exception) {
            null
        }
        val pct = if (level >= 0 && scale > 0) level * 100 / scale else -1
        val counter = try {
            bm?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER)
                ?.takeIf { it != Int.MIN_VALUE && it > 0 }
                ?.let { SysParsers.chargeCounterMah(it, pct) }
        } catch (_: Exception) {
            null
        }
        val screenOn = try {
            ctx.getSystemService(PowerManager::class.java)?.isInteractive ?: false
        } catch (_: Exception) {
            false
        }
        val mi = ActivityManager.MemoryInfo()
        try {
            ctx.getSystemService(ActivityManager::class.java)?.getMemoryInfo(mi)
        } catch (_: Exception) {
        }
        val stat = try {
            StatFs(Environment.getDataDirectory().path)
        } catch (_: Exception) {
            null
        }
        return Reading(
            timeMs = System.currentTimeMillis(),
            level = pct,
            status = status,
            plugged = intent?.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0) ?: 0,
            tempC = (intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) ?: 0) / 10.0,
            voltageMv = SysParsers.voltageMv(intent?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 0) ?: 0),
            currentMa = current?.let { SysParsers.currentMa(it, charging) },
            memTotal = mi.totalMem,
            memAvailable = mi.availMem,
            storageTotal = stat?.totalBytes ?: 0,
            storageFree = stat?.availableBytes ?: 0,
            rxBytes = TrafficStats.getTotalRxBytes(),
            txBytes = TrafficStats.getTotalTxBytes(),
            health = intent?.getIntExtra(BatteryManager.EXTRA_HEALTH, -1) ?: -1,
            chargeCounterMah = counter,
            screenOn = screenOn,
        )
    }
}
