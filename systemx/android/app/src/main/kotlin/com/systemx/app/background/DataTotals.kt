package com.systemx.app.background

import android.app.usage.NetworkStatsManager
import android.content.Context
import android.net.ConnectivityManager
import com.systemx.app.platform.Sys

/**
 * Data used over the last 30 days on mobile data (every SIM) and Wi-Fi,
 * from Android's own network statistics. Needs Usage access; null without
 * it. Read at most every few minutes: the totals change slowly and the
 * query isn't free.
 */
internal object DataTotals {
    private const val DAYS = 30
    private const val REFRESH_MS = 5 * 60_000L

    data class Totals(val mobile: Long, val wifi: Long) {
        val total get() = mobile + wifi
    }

    private var cached: Totals? = null
    private var readAt = 0L

    @Synchronized
    fun last30Days(ctx: Context, now: Long = System.currentTimeMillis()): Totals? {
        if (cached != null && now - readAt < REFRESH_MS) return cached
        val nsm = ctx.getSystemService(NetworkStatsManager::class.java) ?: return null
        val start = now - DAYS * 24 * 3_600_000L
        fun bytes(type: Int): Long? = Sys.safe {
            // A null subscriber means every SIM (Android 10+).
            val b = nsm.querySummaryForDevice(type, null, start, now)
            b.rxBytes + b.txBytes
        }
        val wifi = bytes(ConnectivityManager.TYPE_WIFI)
        val mobile = bytes(ConnectivityManager.TYPE_MOBILE)
        // Both missing usually means no Usage access: try again next time.
        if (wifi == null && mobile == null) return null
        cached = Totals(mobile ?: 0, wifi ?: 0)
        readAt = now
        return cached
    }
}
