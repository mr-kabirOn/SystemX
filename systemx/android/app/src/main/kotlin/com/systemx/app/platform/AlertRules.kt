package com.systemx.app.platform

import java.util.Locale
import kotlin.math.roundToInt

/** Pure decisions for alerts and the status bar text (JVM unit tested). */
internal object AlertRules {
    const val HOUR = 3_600_000L
    const val DAY = 24 * HOUR

    fun chargeLimitReached(level: Int, limit: Int, charging: Boolean) = charging && level >= limit

    fun batteryLow(level: Int, threshold: Int, charging: Boolean) = !charging && level in 0..threshold

    fun batteryHot(tempC: Double, thresholdC: Int) = tempC >= thresholdC

    fun storageFull(total: Long, free: Long, percent: Int) =
        total > 0 && (total - free) * 100 / total >= percent

    /** True when an alert may repeat: never sent, or the cooldown has passed. */
    fun cooldownOver(lastMs: Long, nowMs: Long, cooldownMs: Long) =
        lastMs <= 0 || nowMs - lastMs >= cooldownMs

    fun toF(c: Double) = c * 9 / 5 + 32

    fun temp(c: Double, fahrenheit: Boolean): String =
        if (fahrenheit) "${"%.1f".format(toF(c))} °F" else "${"%.1f".format(c)} °C"

    /**
     * Network speed for the status bar icon as a number and a unit, drawn on
     * two lines so "0" never reads as the letter O: ("850", "KB/s").
     */
    fun rateParts(bytesPerSec: Double): Pair<String, String> = when {
        bytesPerSec < 1_000 -> "0" to "KB/s"
        bytesPerSec < 999_500 -> "${(bytesPerSec / 1000).roundToInt()}" to "KB/s"
        bytesPerSec < 9_950_000 -> String.format(Locale.ROOT, "%.1f", bytesPerSec / 1e6) to "MB/s"
        else -> "${(bytesPerSec / 1e6).roundToInt().coerceAtMost(999)}" to "MB/s"
    }

    /**
     * Status bar icon for [kind] ("battery_level", "battery_temp" or
     * "net_speed") as a number and its unit. Battery values put the unit
     * beside the number ("63" "%"); network speed puts it underneath
     * ([unitBelow]) so "0" never reads as the letter O.
     */
    fun statusIconLines(kind: String, level: Int, tempC: Double, fahrenheit: Boolean, downBps: Double): Pair<String, String> =
        when (kind) {
            "battery_temp" -> "${(if (fahrenheit) toF(tempC) else tempC).roundToInt()}" to (if (fahrenheit) "°F" else "°C")
            "net_speed" -> rateParts(downBps)
            else -> "$level" to "%"
        }

    fun unitBelow(kind: String) = kind == "net_speed"

    /** Bytes per second between two counter readings, 0 on reset or missing data. */
    fun byteRate(prev: Long, now: Long, prevMs: Long, nowMs: Long): Double =
        if (prev < 0 || now < prev || nowMs <= prevMs) 0.0 else (now - prev) * 1000.0 / (nowMs - prevMs)
}

/** Charging session rules. Pure, so they are unit tested. */
internal object SessionRules {
    /**
     * Whether a reading taken while plugged in belongs to a new charge rather
     * than the open session: the charger type changed (e.g. USB to
     * wireless), or the level fell across a gap in readings (the phone ran on
     * battery in between). A fall seen in continuous readings is just heavy
     * use on a weak charger. [lastPlugged] is 0 and [gapMs] null when unknown.
     */
    fun isNewCharge(lastLevel: Int, level: Int, lastPlugged: Int, plugged: Int, gapMs: Long?): Boolean =
        (lastPlugged != 0 && plugged != 0 && plugged != lastPlugged) ||
            (level < lastLevel - 1 && (gapMs == null || gapMs > CONTINUOUS_MS))

    /** Readings closer than this are treated as continuous. */
    const val CONTINUOUS_MS = 3 * 60_000L
}
