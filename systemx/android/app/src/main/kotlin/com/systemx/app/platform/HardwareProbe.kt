package com.systemx.app.platform

import android.app.ActivityManager
import android.app.usage.StorageStatsManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.display.DisplayManager
import android.os.BatteryManager
import android.os.Build
import android.os.Environment
import android.os.StatFs
import android.os.storage.StorageManager
import android.provider.Settings
import android.util.DisplayMetrics
import android.view.Display
import com.systemx.app.background.HistoryDb
import java.io.File

/** Memory, storage, battery and display. */
internal class HardwareProbe(private val ctx: Context) {

    fun memory(): MemoryStats {
        val am = ctx.getSystemService(ActivityManager::class.java)
        val mi = ActivityManager.MemoryInfo().also { am.getMemoryInfo(it) }
        val proc = Sys.meminfo()
        return MemoryStats(
            total = mi.totalMem,
            available = mi.availMem,
            threshold = mi.threshold,
            low = mi.lowMemory,
            advertised = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                mi.advertisedMem.takeIf { it > 0 }
            } else null,
            swapTotal = proc["SwapTotal"]?.times(1024),
            swapFree = proc["SwapFree"]?.times(1024),
        )
    }

    fun storage(): StorageInfo {
        val ssm = ctx.getSystemService(StorageStatsManager::class.java)
        val sm = ctx.getSystemService(StorageManager::class.java)
        val stat = StatFs(Environment.getDataDirectory().path)

        // StorageStatsManager reports the advertised size (e.g. 128 GB) and the
        // free space Settings shows; StatFs is the fallback.
        val advertised = Sys.safe { ssm.getTotalBytes(StorageManager.UUID_DEFAULT) }
        val free = Sys.safe { ssm.getFreeBytes(StorageManager.UUID_DEFAULT) } ?: stat.availableBytes

        val volumes = Sys.safe {
            sm.storageVolumes.map { v ->
                val dir = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) v.directory else null
                val vs = dir?.let { Sys.safe { StatFs(it.path) } }
                StorageVolumeInfo(
                    label = v.getDescription(ctx) ?: "",
                    primary = v.isPrimary,
                    removable = v.isRemovable,
                    state = v.state ?: "unknown",
                    total = vs?.totalBytes,
                    free = vs?.availableBytes,
                )
            }
        } ?: emptyList()

        return StorageInfo(
            total = advertised ?: stat.totalBytes,
            free = free,
            advertised = advertised,
            fsType = dataFsType(),
            volumes = volumes,
        )
    }

    private fun dataFsType(): String? = Sys.safe {
        SysParsers.mountFsType(File("/proc/mounts").readLines(), "/data")
    }

    fun battery(): BatteryInfo {
        val intent = ctx.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val bm = ctx.getSystemService(BatteryManager::class.java)
        val level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = intent?.getIntExtra(BatteryManager.EXTRA_SCALE, 100) ?: 100
        val status = intent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
        val charging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
            status == BatteryManager.BATTERY_STATUS_FULL

        fun prop(id: Int): Int? = Sys.safe { bm.getIntProperty(id) }
            ?.takeIf { it != Int.MIN_VALUE && it != 0 }

        val cycles = cycleCount(intent)
        val tracked = if (cycles == null) Sys.safe { HistoryDb.get(ctx).chargeAdded() } else null

        return BatteryInfo(
            level = (if (level >= 0 && scale > 0) level * 100 / scale else -1).toLong(),
            status = status.toLong(),
            plugged = (intent?.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0) ?: 0).toLong(),
            health = (intent?.getIntExtra(BatteryManager.EXTRA_HEALTH, -1) ?: -1).toLong(),
            tempC = (intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) ?: 0) / 10.0,
            voltageMv = SysParsers.voltageMv(intent?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 0) ?: 0).toLong(),
            technology = intent?.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY)?.ifBlank { null },
            present = intent?.getBooleanExtra(BatteryManager.EXTRA_PRESENT, true) ?: true,
            currentNowMa = prop(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)?.let { SysParsers.currentMa(it, charging) },
            currentAvgMa = prop(BatteryManager.BATTERY_PROPERTY_CURRENT_AVERAGE)?.let { SysParsers.currentMa(it, charging) },
            chargeCounterMah = prop(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER)?.let {
                SysParsers.chargeCounterMah(it, if (level >= 0 && scale > 0) level * 100 / scale else -1)
            },
            chargeTimeRemainingMs = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                Sys.safe { bm.computeChargeTimeRemaining() }?.takeIf { it > 0 }
            } else null,
            cycleCount = cycles,
            designCapacityMah = designCapacity(),
            trackedCycles = tracked?.let { it.first / 100.0 },
            trackedSinceMs = tracked?.second,
        )
    }

    /**
     * Some makers fill EXTRA_CYCLE_COUNT with 0 instead of the real count, so
     * 0 counts as unknown and the kernel's own counter is tried next.
     */
    private fun cycleCount(intent: Intent?): Long? {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            SysParsers.cycleCount(intent?.getIntExtra(BatteryManager.EXTRA_CYCLE_COUNT, -1)?.toLong())
                ?.let { return it }
        }
        return SysParsers.cycleCount(Sys.readLong("/sys/class/power_supply/battery/cycle_count"))
    }

    /** No public API exists; PowerProfile is read by reflection and may be missing. */
    private fun designCapacity(): Double? = Sys.safe {
        val cls = Class.forName("com.android.internal.os.PowerProfile")
        val profile = cls.getConstructor(Context::class.java).newInstance(ctx)
        (cls.getMethod("getBatteryCapacity").invoke(profile) as Double).takeIf { it > 100 }
    }

    fun display(): DisplayInfo {
        val dm = ctx.getSystemService(DisplayManager::class.java)
        val d = dm.getDisplay(Display.DEFAULT_DISPLAY)
        val metrics = DisplayMetrics()
        @Suppress("DEPRECATION") d.getRealMetrics(metrics)
        val mode = d.mode
        val w = minOf(mode.physicalWidth, mode.physicalHeight)
        val h = maxOf(mode.physicalWidth, mode.physicalHeight)
        val cr = ctx.contentResolver

        @Suppress("DEPRECATION")
        val hdr = d.hdrCapabilities?.supportedHdrTypes?.map {
            when (it) {
                Display.HdrCapabilities.HDR_TYPE_DOLBY_VISION -> "Dolby Vision"
                Display.HdrCapabilities.HDR_TYPE_HDR10 -> "HDR10"
                Display.HdrCapabilities.HDR_TYPE_HLG -> "HLG"
                Display.HdrCapabilities.HDR_TYPE_HDR10_PLUS -> "HDR10+"
                else -> "HDR"
            }
        }?.distinct() ?: emptyList()

        return DisplayInfo(
            width = w.toLong(),
            height = h.toLong(),
            densityDpi = metrics.densityDpi.toLong(),
            xdpi = metrics.xdpi.toDouble(),
            ydpi = metrics.ydpi.toDouble(),
            refreshRate = d.refreshRate.toDouble(),
            refreshRates = d.supportedModes.map { it.refreshRate.toDouble() }
                .map { Math.round(it * 10) / 10.0 }.distinct().sorted(),
            hdrTypes = hdr,
            wideColor = d.isWideColorGamut,
            hasCutout = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) d.cutout != null else false,
            brightness = Sys.safe { Settings.System.getInt(cr, Settings.System.SCREEN_BRIGHTNESS) }?.toLong(),
            timeoutMs = Sys.safe { Settings.System.getInt(cr, Settings.System.SCREEN_OFF_TIMEOUT) }?.toLong(),
            fontScale = ctx.resources.configuration.fontScale.toDouble(),
        )
    }
}
