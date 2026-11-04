package com.systemx.app.platform

import android.app.usage.NetworkStats
import android.app.usage.NetworkStatsManager
import android.content.Context
import android.net.ConnectivityManager

/**
 * Wi-Fi and mobile data per app per day from NetworkStatsManager. Needs
 * Usage access. Android keeps these statistics itself (for its own data
 * usage screen), so nothing has to run in the background to collect them.
 */
internal class DataUsageProbe(private val ctx: Context, private val apps: AppsProbe) {

    fun report(dayStarts: List<Long>): DataUsageReport {
        val starts = dayStarts.sorted()
        if (starts.isEmpty() || !apps.usageAccessGranted()) {
            return DataUsageReport(starts.map { empty(it) }, emptyMap())
        }
        val nsm = ctx.getSystemService(NetworkStatsManager::class.java)
            ?: return DataUsageReport(starts.map { empty(it) }, emptyMap())
        val now = System.currentTimeMillis()
        val pm = ctx.packageManager
        val packageCache = HashMap<Int, String?>()
        val packageOf = { uid: Int ->
            packageCache.getOrPut(uid) { Sys.safe { pm.getPackagesForUid(uid)?.firstOrNull() } }
        }

        val days = starts.mapIndexed { i, start ->
            val end = minOf(starts.getOrNull(i + 1) ?: (start + DAY_MS), now)
            val wifi = rows(nsm, ConnectivityManager.TYPE_WIFI, start, end, packageOf)
            val mobile = rows(nsm, ConnectivityManager.TYPE_MOBILE, start, end, packageOf)
            DataUsageDay(
                dayStartMs = start,
                wifiRx = wifi.sumOf { it.rx },
                wifiTx = wifi.sumOf { it.tx },
                mobileRx = mobile.sumOf { it.rx },
                mobileTx = mobile.sumOf { it.tx },
                wifiApps = wifi.map(::toApi),
                mobileApps = mobile.map(::toApi),
            )
        }

        // Names and icons once per package across all days.
        val icons = HashMap<String, ByteArray>()
        val labels = HashMap<String, String>()
        val packages = days.flatMap { d -> (d.wifiApps + d.mobileApps).filter { it.kind == "app" }.map { it.key } }.toSet()
        for (pkg in packages) {
            val info = Sys.safe { pm.getApplicationInfo(pkg, 0) }
            labels[pkg] = info?.let { Sys.safe { it.loadLabel(pm).toString().takeUnless { l -> l == pkg } } }
                ?: SysParsers.packageDisplayName(pkg)
            info?.let { Sys.safe { apps.png(it.loadIcon(pm)) } }?.let { icons[pkg] = it }
        }
        fun named(list: List<AppDataUsage>) = list.map { if (it.kind == "app") it.copy(label = labels[it.key]) else it }
        return DataUsageReport(
            days = days.map { it.copy(wifiApps = named(it.wifiApps), mobileApps = named(it.mobileApps)) },
            icons = icons,
        )
    }

    private fun rows(
        nsm: NetworkStatsManager,
        type: Int,
        start: Long,
        end: Long,
        packageOf: (Int) -> String?,
    ): List<DataUsageCalc.Row> {
        if (end <= start) return emptyList()
        val buckets = ArrayList<DataUsageCalc.Bucket>()
        // A null subscriber means every SIM on Android 10+; older versions
        // return nothing for mobile without the (now restricted) subscriber ID.
        val stats = Sys.safe { nsm.querySummary(type, null, start, end) } ?: return emptyList()
        stats.use { s ->
            val b = NetworkStats.Bucket()
            while (s.hasNextBucket()) {
                s.getNextBucket(b)
                buckets += DataUsageCalc.Bucket(b.uid, b.rxBytes, b.txBytes)
            }
        }
        return DataUsageCalc.group(buckets, packageOf)
    }

    private fun toApi(r: DataUsageCalc.Row) = AppDataUsage(key = r.key, kind = r.kind, rxBytes = r.rx, txBytes = r.tx)

    private fun empty(start: Long) = DataUsageDay(
        dayStartMs = start, wifiRx = 0, wifiTx = 0, mobileRx = 0, mobileTx = 0,
        wifiApps = emptyList(), mobileApps = emptyList(),
    )

    private companion object {
        const val DAY_MS = 24 * 3_600_000L
    }
}
