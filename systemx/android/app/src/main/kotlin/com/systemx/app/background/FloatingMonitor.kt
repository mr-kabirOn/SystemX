package com.systemx.app.background

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.provider.Settings
import android.util.TypedValue
import android.view.Choreographer
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.LinearLayout
import android.widget.TextView
import com.systemx.app.platform.AlertRules
import com.systemx.app.platform.BackgroundConfig
import java.util.Locale
import kotlin.math.abs
import kotlin.math.roundToInt

/**
 * A small box drawn over other apps (Display over other apps permission)
 * with the values the user picked. Run by [LiveStatusService], which keeps
 * the app alive while it shows.
 *
 * "FPS" is how many frames the screen draws per second, counted with
 * Choreographer. Apps can't read another app's own frame rate without root,
 * so this is the display's current refresh rate, which on adaptive screens
 * follows what is on screen.
 */
internal class FloatingMonitor(private val ctx: Context) {
    private val wm = ctx.getSystemService(WindowManager::class.java)
    private var root: LinearLayout? = null
    private val rows = LinkedHashMap<String, TextView>()
    private var shownConfig: String? = null

    // Frame counting.
    private var frames = 0
    private var windowStart = 0L
    private var fps = 0
    private var counting = false
    private val frameCallback = object : Choreographer.FrameCallback {
        override fun doFrame(frameTimeNanos: Long) {
            if (!counting) return
            frames++
            if (windowStart == 0L) windowStart = frameTimeNanos
            val elapsed = frameTimeNanos - windowStart
            if (elapsed >= 1_000_000_000L) {
                fps = (frames * 1_000_000_000.0 / elapsed).roundToInt()
                frames = 0
                windowStart = frameTimeNanos
                rows["fps"]?.text = fps.toString()
            }
            Choreographer.getInstance().postFrameCallback(this)
        }
    }

    val isShowing get() = root != null

    /** Shows, rebuilds or hides the box to match [c]. */
    fun apply(c: BackgroundConfig) {
        if (!c.overlay || !canDraw(ctx)) {
            hide()
            return
        }
        val key = listOf(c.overlayItems, c.overlayOpacity, c.overlayDark).toString()
        if (root != null && key == shownConfig) return
        hide()
        show(c)
        shownConfig = key
    }

    /** Pauses frame counting while the screen is off. */
    fun setScreenOn(on: Boolean) {
        if (root == null) return
        if (on) startCounting() else stopCounting()
    }

    /** New readings from the service tick. */
    /** [speedBps] is the internet speed, download and upload together. */
    fun update(r: Reading, speedBps: Double, fahrenheit: Boolean) {
        if (root == null) return
        val ma = r.currentMa
        rows["ram_used"]?.text = "${(r.memUsed * 100).roundToInt()}%"
        rows["ram_free"]?.text = gb(r.memAvailable)
        rows["current"]?.text = ma?.let { "${if (it > 0) "+" else ""}$it mA" } ?: "–"
        rows["power"]?.text = if (ma != null && ma != 0L && r.voltageMv > 0) {
            String.format(Locale.ROOT, "%.1f W", abs(ma) * r.voltageMv / 1e6)
        } else "–"
        rows["temp"]?.text = AlertRules.temp(r.tempC, fahrenheit)
        rows["speed"]?.text = AlertRules.rateParts(speedBps).let { (v, u) -> "$v $u" }
    }

    fun hide() {
        stopCounting()
        root?.let { v -> runCatching { wm?.removeView(v) } }
        root = null
        rows.clear()
        shownConfig = null
    }

    @SuppressLint("ClickableViewAccessibility")
    private fun show(c: BackgroundConfig) {
        val wm = wm ?: return
        val dark = c.overlayDark
        val ink = if (dark) Color.WHITE else Color.rgb(0x16, 0x1A, 0x2C)
        val muted = if (dark) Color.argb(0xB3, 0xFF, 0xFF, 0xFF) else Color.rgb(0x5E, 0x65, 0x84)
        val alpha = (c.overlayOpacity.coerceIn(20L, 100L) * 255 / 100).toInt()
        val box = LinearLayout(ctx).apply {
            orientation = LinearLayout.VERTICAL
            val pad = dp(8)
            setPadding(dp(10), pad, dp(10), pad)
            background = GradientDrawable().apply {
                cornerRadius = dp(12).toFloat()
                setColor(if (dark) Color.argb(alpha, 0, 0, 0) else Color.argb(alpha, 255, 255, 255))
            }
        }
        val single = c.overlayItems.size == 1
        for (item in c.overlayItems) {
            val label = TextView(ctx).apply {
                text = labelFor(item)
                setTextColor(muted)
                setTextSize(TypedValue.COMPLEX_UNIT_SP, if (single) 11f else 10f)
            }
            val value = TextView(ctx).apply {
                text = "–"
                setTextColor(ink)
                typeface = Typeface.create("sans-serif-medium", Typeface.NORMAL)
                setTextSize(TypedValue.COMPLEX_UNIT_SP, if (single) 20f else 13f)
            }
            if (single) {
                // One value: label above a large number, like a gauge.
                box.addView(label)
                box.addView(value)
            } else {
                box.addView(LinearLayout(ctx).apply {
                    orientation = LinearLayout.HORIZONTAL
                    gravity = Gravity.CENTER_VERTICAL
                    addView(label, LinearLayout.LayoutParams(dp(42), LinearLayout.LayoutParams.WRAP_CONTENT))
                    addView(value)
                })
            }
            rows[item] = value
        }

        val prefs = ConfigStore.prefs(ctx)
        val lp = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT,
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = prefs.getInt("overlayX", dp(8))
            y = prefs.getInt("overlayY", dp(120))
        }

        // Drag to move; the position is kept for next time.
        var downX = 0f
        var downY = 0f
        var startX = 0
        var startY = 0
        box.setOnTouchListener { v, e ->
            when (e.actionMasked) {
                MotionEvent.ACTION_DOWN -> {
                    downX = e.rawX
                    downY = e.rawY
                    startX = lp.x
                    startY = lp.y
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    lp.x = startX + (e.rawX - downX).roundToInt()
                    lp.y = startY + (e.rawY - downY).roundToInt()
                    runCatching { wm.updateViewLayout(v, lp) }
                    true
                }
                MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL -> {
                    prefs.edit().putInt("overlayX", lp.x).putInt("overlayY", lp.y).apply()
                    true
                }
                else -> false
            }
        }
        box.importantForAccessibility = View.IMPORTANT_FOR_ACCESSIBILITY_NO_HIDE_DESCENDANTS

        try {
            wm.addView(box, lp)
        } catch (_: Exception) {
            // Permission withdrawn or window refused: nothing to show.
            rows.clear()
            return
        }
        root = box
        if ("fps" in c.overlayItems) startCounting()
    }

    private fun startCounting() {
        if (counting || "fps" !in rows) return
        counting = true
        frames = 0
        windowStart = 0L
        Choreographer.getInstance().postFrameCallback(frameCallback)
    }

    private fun stopCounting() {
        counting = false
        Choreographer.getInstance().removeFrameCallback(frameCallback)
    }

    private fun labelFor(item: String): String = when (item) {
        "fps" -> "FPS"
        "ram_used" -> "RAM"
        "ram_free" -> ctx.getString(com.systemx.app.R.string.o_free)
        "current" -> "mA"
        "power" -> "W"
        "temp" -> ctx.getString(com.systemx.app.R.string.o_temp)
        "speed" -> "⇅"
        else -> item
    }

    private fun gb(bytes: Long) = String.format(Locale.ROOT, "%.1f GB", bytes / 1_073_741_824.0)

    private fun dp(v: Int) = (v * ctx.resources.displayMetrics.density).roundToInt()

    companion object {
        fun canDraw(ctx: Context): Boolean = Settings.canDrawOverlays(ctx)
    }
}
