package com.systemx.app.background

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import com.systemx.app.R

/** Notification channels (each can be muted in Android settings) and posting. */
internal object Notifications {
    const val LIVE = "live_status"
    const val BATTERY = "battery_alerts"
    const val STORAGE = "storage_alerts"
    const val SUMMARY = "summaries"

    const val ID_LIVE = 1
    const val ID_CHARGE_LIMIT = 10
    const val ID_LOW = 11
    const val ID_HOT = 12
    const val ID_FULL = 13
    const val ID_STORAGE = 20
    const val ID_WEEKLY = 30
    const val ID_REMINDER = 31

    fun ensureChannels(ctx: Context) {
        val nm = ctx.getSystemService(NotificationManager::class.java) ?: return
        nm.createNotificationChannels(
            listOf(
                NotificationChannel(LIVE, ctx.getString(R.string.ch_live), NotificationManager.IMPORTANCE_LOW)
                    .apply { setShowBadge(false) },
                NotificationChannel(BATTERY, ctx.getString(R.string.ch_battery), NotificationManager.IMPORTANCE_DEFAULT),
                NotificationChannel(STORAGE, ctx.getString(R.string.ch_storage), NotificationManager.IMPORTANCE_DEFAULT),
                NotificationChannel(SUMMARY, ctx.getString(R.string.ch_summary), NotificationManager.IMPORTANCE_LOW),
            ),
        )
    }

    /** Opens the app at [path] (a go_router location such as "/live/battery"). */
    fun openApp(ctx: Context, path: String, requestCode: Int): PendingIntent {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse("systemx://open$path"))
            .setPackage(ctx.packageName)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        return PendingIntent.getActivity(
            ctx, requestCode, intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
    }

    fun canPost(ctx: Context): Boolean =
        ctx.getSystemService(NotificationManager::class.java)?.areNotificationsEnabled() == true

    fun post(ctx: Context, id: Int, channel: String, title: String, text: String, path: String) {
        if (!canPost(ctx)) return
        ensureChannels(ctx)
        val n = Notification.Builder(ctx, channel)
            .setSmallIcon(R.drawable.ic_launcher_monochrome)
            .setContentTitle(title)
            .setContentText(text)
            .setStyle(Notification.BigTextStyle().bigText(text))
            .setContentIntent(openApp(ctx, path, id))
            .setAutoCancel(true)
            .build()
        try {
            ctx.getSystemService(NotificationManager::class.java)?.notify(id, n)
        } catch (_: SecurityException) {
        }
    }
}
