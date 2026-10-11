package com.systemx.app.platform

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

    /** Up to four characters for the status bar icon: "2.4M", "850K". */
    fun rateShort(bytesPerSec: Double): String = when {
        bytesPerSec < 1_000 -> "0K"
        bytesPerSec < 1_000_000 -> "${(bytesPerSec / 1000).roundToInt().coerceAtMost(999)}K"
        bytesPerSec < 10_000_000 -> "${"%.1f".format(bytesPerSec / 1e6)}M"
        else -> "${(bytesPerSec / 1e6).roundToInt().coerceAtMost(999)}M"
    }

    /** Status bar icon text for [kind]: "battery_level", "battery_temp" or "net_speed". */
    fun statusIconText(kind: String, level: Int, tempC: Double, fahrenheit: Boolean, downBps: Double): String =
        when (kind) {
            "battery_temp" -> "${(if (fahrenheit) toF(tempC) else tempC).roundToInt()}°"
            "net_speed" -> rateShort(downBps)
            else -> "$level"
        }

    /** Bytes per second between two counter readings, 0 on reset or missing data. */
    fun byteRate(prev: Long, now: Long, prevMs: Long, nowMs: Long): Double =
        if (prev < 0 || now < prev || nowMs <= prevMs) 0.0 else (now - prev) * 1000.0 / (nowMs - prevMs)
}
