package com.systemx.app.background

import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.graphics.drawable.Icon
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import com.systemx.app.R
import com.systemx.app.platform.AlertRules
import kotlin.math.abs
import kotlin.math.roundToInt

/**
 * Optional ongoing notification with battery, temperature, charging power,
 * network speed and RAM, and a number in the status bar. Off by default;
 * the user starts it in Settings and can stop it from the notification.
 */
class LiveStatusService : Service() {
    private val handler = Handler(Looper.getMainLooper())
    private var prev: Reading? = null
    private var ticks = 0

    private val tick = object : Runnable {
        override fun run() {
            update()
            handler.postDelayed(this, INTERVAL)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            ConfigStore.setLiveStatus(this, false)
            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()
            return START_NOT_STICKY
        }
        Notifications.ensureChannels(this)
        val r = Readings.read(this)
        val n = build(r, 0.0, 0.0)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(Notifications.ID_LIVE, n, ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE)
        } else {
            startForeground(Notifications.ID_LIVE, n)
        }
        prev = r
        handler.removeCallbacks(tick)
        handler.postDelayed(tick, INTERVAL)
        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(tick)
        super.onDestroy()
    }

    private fun update() {
        val r = try {
            Readings.read(this)
        } catch (_: Exception) {
            return
        }
        val p = prev
        val down = if (p == null) 0.0 else AlertRules.byteRate(p.rxBytes, r.rxBytes, p.timeMs, r.timeMs)
        val up = if (p == null) 0.0 else AlertRules.byteRate(p.txBytes, r.txBytes, p.timeMs, r.timeMs)
        prev = r
        Sampler.onReading(this, r)
        try {
            getSystemService(android.app.NotificationManager::class.java)
                ?.notify(Notifications.ID_LIVE, build(r, down, up))
        } catch (_: SecurityException) {
        }
        if (++ticks % 15 == 0) WidgetUpdater.update(this, r) // every 30 s
    }

    private fun build(r: Reading, down: Double, up: Double): Notification {
        val c = ConfigStore.load(this)
        val parts = mutableListOf("${r.level}%", AlertRules.temp(r.tempC, c.fahrenheit))
        val ma = r.currentMa
        if (r.pluggedIn && ma != null && ma > 0) {
            val watts = abs(ma) * r.voltageMv / 1e6
            parts += getString(R.string.live_charging_w, "%.1f".format(watts))
        }
        val text = getString(
            R.string.live_text, rate(down), rate(up), (r.memUsed * 100).roundToInt(),
        )
        val stop = PendingIntent.getService(
            this, 1, Intent(this, LiveStatusService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        val icon = textIcon(AlertRules.statusIconText(c.statusIcon, r.level, r.tempC, c.fahrenheit, down))
        return Notification.Builder(this, Notifications.LIVE)
            .setSmallIcon(icon)
            .setContentTitle(parts.joinToString(" · "))
            .setContentText(text)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setShowWhen(false)
            .setCategory(Notification.CATEGORY_STATUS)
            .setContentIntent(Notifications.openApp(this, "/monitor", 2))
            .addAction(Notification.Action.Builder(null as Icon?, getString(R.string.live_stop), stop).build())
            .build()
    }

    private fun rate(bps: Double): String = when {
        bps < 1_000 -> "${bps.roundToInt()} B/s"
        bps < 1_000_000 -> "${(bps / 1000).roundToInt()} KB/s"
        else -> "${"%.1f".format(bps / 1e6)} MB/s"
    }

    /** White text on transparent, as Android requires for status bar icons. */
    private fun textIcon(text: String): Icon {
        val size = 96
        val bmp = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.WHITE
            textAlign = Paint.Align.CENTER
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
            textSize = 72f
        }
        while (paint.measureText(text) > size - 4 && paint.textSize > 24f) paint.textSize -= 4f
        val y = size / 2f - (paint.descent() + paint.ascent()) / 2
        Canvas(bmp).drawText(text, size / 2f, y, paint)
        return Icon.createWithBitmap(bmp)
    }

    companion object {
        private const val INTERVAL = 2_000L
        private const val ACTION_STOP = "com.systemx.app.STOP_LIVE_STATUS"

        fun start(ctx: Context) {
            if (!Notifications.canPost(ctx)) return
            try {
                ctx.startForegroundService(Intent(ctx, LiveStatusService::class.java))
            } catch (_: Exception) {
                // Android may refuse to start it from the background; it starts
                // next time the app opens.
            }
        }

        fun stop(ctx: Context) {
            ctx.stopService(Intent(ctx, LiveStatusService::class.java))
        }
    }
}
