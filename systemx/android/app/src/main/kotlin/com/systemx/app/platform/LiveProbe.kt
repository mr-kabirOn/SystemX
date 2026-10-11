package com.systemx.app.platform

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.TrafficStats
import android.os.BatteryManager
import android.os.Build
import android.os.PowerManager
import android.os.SystemClock
import java.io.File

/**
 * One cheap snapshot of everything that changes second to second, read on
 * every dashboard tick. Static paths are found once and cached.
 */
internal class LiveProbe(private val ctx: Context) {
    private val am = ctx.getSystemService(ActivityManager::class.java)
    private val bm = ctx.getSystemService(BatteryManager::class.java)
    private val pm = ctx.getSystemService(PowerManager::class.java)

    private val coreCount: Int by lazy {
        Sys.safe {
            File("/sys/devices/system/cpu/").listFiles { f -> f.name.matches(Regex("cpu\\d+")) }?.size
        }?.takeIf { it > 0 } ?: Runtime.getRuntime().availableProcessors()
    }

    private val maxKhz: List<Long> by lazy {
        (0 until coreCount).map { Sys.readLong("/sys/devices/system/cpu/cpu$it/cpufreq/cpuinfo_max_freq") ?: 0L }
    }

    /** Temperature files of CPU thermal zones; empty when the phone hides them. */
    private val cpuZoneFiles: List<String> by lazy {
        val types = (0 until 64).mapNotNull { i ->
            Sys.read("/sys/class/thermal/thermal_zone$i/type")?.let { i to it }
        }.toMap()
        SysParsers.cpuThermalZones(types).take(12).map { "/sys/class/thermal/thermal_zone$it/temp" }
    }

    fun live(): LiveStats {
        val mi = ActivityManager.MemoryInfo().also { am.getMemoryInfo(it) }
        val intent = ctx.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = intent?.getIntExtra(BatteryManager.EXTRA_SCALE, 100) ?: 100
        val status = intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
        val charging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
            status == BatteryManager.BATTERY_STATUS_FULL
        val current = Sys.safe { bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW) }
            ?.takeIf { it != Int.MIN_VALUE && it != 0 }

        val cpuKhz = (0 until coreCount).map { i ->
            Sys.readLong("/sys/devices/system/cpu/cpu$i/cpufreq/scaling_cur_freq") ?: 0L
        }
        val cpuTemp = cpuZoneFiles.mapNotNull { f -> Sys.readLong(f)?.let { SysParsers.thermalC(it) } }.maxOrNull()

        val thermalStatus = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            Sys.safe { pm.currentThermalStatus }?.toLong() ?: -1L
        } else -1L
        val headroom = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            Sys.safe { pm.getThermalHeadroom(0) }?.takeIf { !it.isNaN() }?.toDouble()
        } else null

        return LiveStats(
            timeMs = SystemClock.elapsedRealtime(),
            cpuKhz = cpuKhz,
            cpuMaxKhz = maxKhz,
            memTotal = mi.totalMem,
            memAvailable = mi.availMem,
            batteryLevel = (if (level >= 0 && scale > 0) level * 100 / scale else -1).toLong(),
            batteryStatus = status.toLong(),
            plugged = (intent?.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0) ?: 0).toLong(),
            batteryTempC = (intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) ?: 0) / 10.0,
            voltageMv = SysParsers.voltageMv(intent?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 0) ?: 0).toLong(),
            currentNowMa = current?.let { SysParsers.currentMa(it, charging) },
            rxBytes = TrafficStats.getTotalRxBytes(),
            txBytes = TrafficStats.getTotalTxBytes(),
            thermalStatus = thermalStatus,
            thermalHeadroom = headroom,
            cpuTempC = cpuTemp,
        )
    }
}
