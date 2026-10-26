package com.systemx.app.platform

import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import com.systemx.app.background.HistoryDb

/**
 * Screen time from Android's usage events (needs Usage access) and battery
 * estimates from SystemX's own battery history. See [ScreenTimeCalc].
 */
internal class ScreenTimeProbe(private val ctx: Context, private val apps: AppsProbe) {

    fun report(dayStarts: List<Long>): ScreenTimeReport {
        val now = System.currentTimeMillis()
        val starts = dayStarts.sorted()
        if (starts.isEmpty() || !apps.usageAccessGranted()) {
            return ScreenTimeReport(starts.map { UsageDay(dayStartMs = it, screenOnMs = 0, apps = emptyList()) }, emptyMap())
        }
        // Start a little early to learn which app was on screen at midnight.
        val events = Sys.safe { readEvents(starts.first() - LEAD_MS, now) } ?: emptyList()
        val levels = Sys.safe {
            HistoryDb.get(ctx).samples(starts.first() - ScreenTimeCalc.MAX_GAP_MS)
                .map { ScreenTimeCalc.Level(it.timeMs, it.level.toInt(), it.charging) }
        } ?: emptyList()
        val days = ScreenTimeCalc.days(starts, now, events, levels, excluded())

        val pm = ctx.packageManager
        val labels = HashMap<String, String>()
        val icons = HashMap<String, ByteArray>()
        for (pkg in days.flatMap { d -> d.apps.map { it.pkg } }.toSet()) {
            val info = Sys.safe { pm.getApplicationInfo(pkg, 0) }
            labels[pkg] = info?.let { Sys.safe { it.loadLabel(pm).toString() } } ?: pkg
            info?.let { i -> Sys.safe { apps.png(i.loadIcon(pm)) } }?.let { icons[pkg] = it }
        }
        return ScreenTimeReport(
            days = days.map { d ->
                UsageDay(
                    dayStartMs = d.start,
                    screenOnMs = d.screenMs,
                    unlocks = d.unlocks?.toLong(),
                    drainPct = d.drain?.toLong(),
                    screenDrainPct = d.screenDrain,
                    apps = d.apps.map {
                        AppUsage(
                            packageName = it.pkg,
                            label = labels[it.pkg] ?: it.pkg,
                            foregroundMs = it.ms,
                            opens = it.opens.toLong(),
                            batteryPct = it.battery,
                        )
                    },
                )
            },
            icons = icons,
        )
    }

    private fun readEvents(from: Long, to: Long): List<ScreenTimeCalc.Ev> {
        val usm = ctx.getSystemService(UsageStatsManager::class.java) ?: return emptyList()
        val wanted = setOf(
            ScreenTimeCalc.RESUMED, ScreenTimeCalc.PAUSED, ScreenTimeCalc.STOPPED,
            ScreenTimeCalc.SCREEN_ON, ScreenTimeCalc.SCREEN_OFF,
            ScreenTimeCalc.UNLOCKED, ScreenTimeCalc.SHUTDOWN,
        )
        val out = ArrayList<ScreenTimeCalc.Ev>()
        val q = usm.queryEvents(from, to) ?: return out
        val e = UsageEvents.Event()
        while (q.hasNextEvent()) {
            q.getNextEvent(e)
            if (e.eventType in wanted) out += ScreenTimeCalc.Ev(e.timeStamp, e.eventType, e.packageName)
        }
        return out
    }

    /** Home screens and system UI: part of screen time, but not "apps". */
    private fun excluded(): Set<String> {
        val pm = ctx.packageManager
        val home = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)
        val launchers = Sys.safe {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                pm.queryIntentActivities(home, PackageManager.ResolveInfoFlags.of(0))
            } else {
                @Suppress("DEPRECATION") pm.queryIntentActivities(home, 0)
            }
        }?.map { it.activityInfo.packageName } ?: emptyList()
        return launchers.toSet() + setOf("android", "com.android.systemui")
    }

    private companion object {
        const val LEAD_MS = 6 * 3_600_000L
    }
}
