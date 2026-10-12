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
import android.os.BatteryManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import com.systemx.app.R
import com.systemx.app.platform.AlertRules
import java.util.Locale
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
        // Every number says what it is: "Battery 63% · Health Good".
        val title = listOfNotNull(
            getString(R.string.live_battery, r.level),
            healthName(r.health)?.let { getString(R.string.live_health, it) },
        ).joinToString(" · ")
        val battery = mutableListOf(getString(R.string.live_temp, AlertRules.temp(r.tempC, c.fahrenheit)))
        val ma = r.currentMa
        if (r.pluggedIn && ma != null && ma > 0) {
            val watts = abs(ma) * r.voltageMv / 1e6
            battery += getString(R.string.live_charging_w, String.format(Locale.ROOT, "%.1f", watts))
        }
        val line1 = battery.joinToString(" · ")
        val line2 = getString(R.string.live_text, rate(down), rate(up), (r.memUsed * 100).roundToInt())
        val stop = PendingIntent.getService(
            this, 1, Intent(this, LiveStatusService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        val (value, unit) = AlertRules.statusIconLines(c.statusIcon, r.level, r.tempC, c.fahrenheit, down)
        return Notification.Builder(this, Notifications.LIVE)
            .setSmallIcon(textIcon(value, unit))
            .setContentTitle(title)
            .setContentText(line1)
            .setStyle(Notification.BigTextStyle().bigText("$line1\n$line2"))
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setShowWhen(false)
            .setCategory(Notification.CATEGORY_STATUS)
            .setContentIntent(Notifications.openApp(this, "/monitor", 2))
            .addAction(Notification.Action.Builder(null as Icon?, getString(R.string.live_stop), stop).build())
            .build()
    }

    private fun healthName(health: Int): String? = when (health) {
        BatteryManager.BATTERY_HEALTH_GOOD -> getString(R.string.health_good)
        BatteryManager.BATTERY_HEALTH_OVERHEAT -> getString(R.string.health_overheat)
        BatteryManager.BATTERY_HEALTH_DEAD -> getString(R.string.health_dead)
        BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> getString(R.string.health_over_voltage)
        BatteryManager.BATTERY_HEALTH_COLD -> getString(R.string.health_cold)
        BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> getString(R.string.health_failure)
        else -> null
    }

    private fun rate(bps: Double): String = when {
        bps < 1_000 -> "${bps.roundToInt()} B/s"
        bps < 1_000_000 -> "${(bps / 1000).roundToInt()} KB/s"
        else -> "${String.format(Locale.ROOT, "%.1f", bps / 1e6)} MB/s"
    }

    /**
     * White on transparent, as Android requires for status bar icons: the
     * value large on top and its unit smaller underneath, like the clock
     * area's other indicators.
     */
    private fun textIcon(value: String, unit: String): Icon {
        val size = 96
        val bmp = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bmp)
        fun paint(textSize: Float, bold: Boolean) = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.WHITE
            textAlign = Paint.Align.CENTER
            typeface = Typeface.create(Typeface.DEFAULT, if (bold) Typeface.BOLD else Typeface.NORMAL)
            this.textSize = textSize
        }
        val top = paint(60f, true)
        while (top.measureText(value) > size - 2 && top.textSize > 24f) top.textSize -= 2f
        val bottom = paint(34f, true)
        while (bottom.measureText(unit) > size - 2 && bottom.textSize > 16f) bottom.textSize -= 2f
        // Value baseline in the top 60%, unit baseline near the bottom.
        canvas.drawText(value, size / 2f, size * 0.56f, top)
        canvas.drawText(unit, size / 2f, size * 0.94f, bottom)
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
