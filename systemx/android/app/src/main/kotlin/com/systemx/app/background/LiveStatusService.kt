package com.systemx.app.background

import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
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
import android.os.PowerManager
import android.widget.RemoteViews
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
    private var screenOn = true
    private var lastShown: String? = null
    private var receiverRegistered = false

    private val tick = object : Runnable {
        override fun run() {
            update()
            // Nobody sees the notification with the screen off: read rarely,
            // just enough to keep history and alerts going.
            handler.postDelayed(this, if (screenOn) INTERVAL else SCREEN_OFF_INTERVAL)
        }
    }

    private val screenReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            screenOn = intent.action != Intent.ACTION_SCREEN_OFF
            if (screenOn) {
                // Speeds are measured across the gap; start fresh.
                prev = null
                handler.removeCallbacks(tick)
                handler.post(tick)
            }
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
        val n = build(r, 0.0, 0.0)!!
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                startForeground(Notifications.ID_LIVE, n, ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE)
            } else {
                startForeground(Notifications.ID_LIVE, n)
            }
        } catch (_: Exception) {
            // Android may refuse, e.g. when it restarts the service from the
            // background on 12+. Stop quietly; the user can start it again.
            stopSelf()
            return START_NOT_STICKY
        }
        if (!receiverRegistered) {
            registerReceiver(
                screenReceiver,
                IntentFilter().apply {
                    addAction(Intent.ACTION_SCREEN_ON)
                    addAction(Intent.ACTION_SCREEN_OFF)
                },
            )
            receiverRegistered = true
        }
        screenOn = getSystemService(PowerManager::class.java)?.isInteractive ?: true
        prev = r
        handler.removeCallbacks(tick)
        handler.postDelayed(tick, INTERVAL)
        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(tick)
        if (receiverRegistered) {
            try {
                unregisterReceiver(screenReceiver)
            } catch (_: IllegalArgumentException) {
            }
            receiverRegistered = false
        }
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
        val n = build(r, down, up, skipIfUnchanged = true)
        if (n != null) {
            try {
                getSystemService(android.app.NotificationManager::class.java)?.notify(Notifications.ID_LIVE, n)
            } catch (_: SecurityException) {
            }
        }
        if (++ticks % 15 == 0) WidgetUpdater.update(this, r) // every 30 s
    }

    /** Null when [skipIfUnchanged] and every shown value is the same as last time. */
    private fun build(r: Reading, down: Double, up: Double, skipIfUnchanged: Boolean = false): Notification? {
        val c = ConfigStore.load(this)
        val battery = "${r.level}%"
        val batteryLabel = healthName(r.health)?.let { getString(R.string.live_health, it) }
            ?: getString(R.string.n_label_battery)
        val temp = AlertRules.temp(r.tempC, c.fahrenheit)
        val ram = "${(r.memUsed * 100).roundToInt()}%"
        // Charging power while plugged in, otherwise what the phone draws.
        val ma = r.currentMa
        val watts = if (ma != null && ma != 0L && r.voltageMv > 0) abs(ma) * r.voltageMv / 1e6 else null
        val power = watts?.let { String.format(Locale.ROOT, "%.1f W", it) } ?: "–"
        val powerLabel = getString(
            when {
                watts == null -> R.string.n_label_power
                r.pluggedIn && ma != null && ma > 0 -> R.string.n_label_charging
                else -> R.string.n_label_using
            },
        )

        val (value, unit) = AlertRules.statusIconLines(c.statusIcon, r.level, r.tempC, c.fahrenheit, down)
        val shown = listOf(battery, batteryLabel, temp, power, powerLabel, rate(down), rate(up), ram, value, unit, c.statusIcon)
            .joinToString("|")
        if (skipIfUnchanged && shown == lastShown) return null
        lastShown = shown

        val small = RemoteViews(packageName, R.layout.notif_live_small).apply {
            setTextViewText(R.id.s_battery, battery)
            setTextViewText(R.id.s_temp, temp)
            setTextViewText(R.id.s_down, rate(down))
            setTextViewText(R.id.s_ram, ram)
        }
        val big = RemoteViews(packageName, R.layout.notif_live_big).apply {
            setTextViewText(R.id.battery_value, battery)
            setTextViewText(R.id.battery_label, batteryLabel)
            setTextViewText(R.id.temp_value, temp)
            setTextViewText(R.id.temp_label, getString(R.string.n_label_temp))
            setTextViewText(R.id.power_value, power)
            setTextViewText(R.id.power_label, powerLabel)
            setTextViewText(R.id.down_value, rate(down))
            setTextViewText(R.id.down_label, getString(R.string.n_label_down))
            setTextViewText(R.id.up_value, rate(up))
            setTextViewText(R.id.up_label, getString(R.string.n_label_up))
            setTextViewText(R.id.ram_value, ram)
            setTextViewText(R.id.ram_label, getString(R.string.n_label_ram))
        }

        val stop = PendingIntent.getService(
            this, 1, Intent(this, LiveStatusService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        return Notification.Builder(this, Notifications.LIVE)
            .setSmallIcon(textIcon(value, unit, AlertRules.unitBelow(c.statusIcon)))
            // Plain text for places that don't show custom layouts (lock
            // screen in some modes, accessibility, wearables).
            .setContentTitle(getString(R.string.live_battery, r.level) + " · " + batteryLabel)
            .setContentText(getString(R.string.live_temp, temp))
            .setStyle(Notification.DecoratedCustomViewStyle())
            .setCustomContentView(small)
            .setCustomBigContentView(big)
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
     * White on transparent, as Android requires for status bar icons. The
     * number is drawn at the same size for every option; battery values
     * put the unit small beside it ("63%"), network speed underneath it
     * ("0" over "KB/s") so the number never reads as a letter.
     */
    private fun textIcon(value: String, unit: String, unitBelow: Boolean): Icon {
        val size = 96
        val bmp = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bmp)
        fun paint(textSize: Float, align: Paint.Align) = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.WHITE
            textAlign = align
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
            this.textSize = textSize
        }
        if (unitBelow) {
            val top = paint(60f, Paint.Align.CENTER)
            while (top.measureText(value) > size - 2 && top.textSize > 24f) top.textSize -= 2f
            val bottom = paint(34f, Paint.Align.CENTER)
            while (bottom.measureText(unit) > size - 2 && bottom.textSize > 16f) bottom.textSize -= 2f
            canvas.drawText(value, size / 2f, size * 0.56f, top)
            canvas.drawText(unit, size / 2f, size * 0.94f, bottom)
        } else {
            val num = paint(60f, Paint.Align.LEFT)
            val small = paint(34f, Paint.Align.LEFT)
            // Shrink both together until number and unit fit side by side.
            while (num.measureText(value) + small.measureText(unit) > size - 2 && num.textSize > 24f) {
                num.textSize -= 2f
                small.textSize = num.textSize * 0.57f
            }
            val total = num.measureText(value) + small.measureText(unit)
            val x = (size - total) / 2f
            val baseline = size / 2f - (num.descent() + num.ascent()) / 2
            canvas.drawText(value, x, baseline, num)
            canvas.drawText(unit, x + num.measureText(value), baseline, small)
        }
        return Icon.createWithBitmap(bmp)
    }

    companion object {
        private const val INTERVAL = 2_000L
        private const val SCREEN_OFF_INTERVAL = 60_000L
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
