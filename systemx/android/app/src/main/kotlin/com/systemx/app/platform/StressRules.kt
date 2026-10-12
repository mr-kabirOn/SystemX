package com.systemx.app.platform

/**
 * When the CPU stress test must stop. Pure, so it is JVM unit tested; the
 * runner checks it every second on its own thread, whatever the UI does.
 */
internal object StressRules {
    /** Hard cap on any run, whatever the screen asked for. */
    const val MAX_MS = 180_000L

    /** Battery temperature the test never goes past. */
    const val MAX_BATTERY_C = 45.0

    /** The test needs at least this much battery when not plugged in. */
    const val MIN_LEVEL = 15

    /** PowerManager.THERMAL_STATUS_SEVERE. */
    const val THERMAL_SEVERE = 3

    /** Stop when the screen hasn't asked for a reading in this long (app closed or crashed). */
    const val IDLE_MS = 5_000L

    /** Reason to refuse starting, or null when it is safe to start. */
    fun refuseStart(batteryC: Double, level: Int, plugged: Boolean, thermalStatus: Int): String? = when {
        batteryC >= MAX_BATTERY_C - 3 -> "hot"
        thermalStatus >= THERMAL_SEVERE - 1 -> "hot"
        level in 0 until MIN_LEVEL + 5 && !plugged -> "battery"
        else -> null
    }

    /** Reason to stop now, or null to keep going. */
    fun stopReason(
        elapsedMs: Long,
        durationMs: Long,
        batteryC: Double,
        level: Int,
        plugged: Boolean,
        thermalStatus: Int,
        sinceLastPollMs: Long,
    ): String? = when {
        batteryC >= MAX_BATTERY_C -> "hot"
        thermalStatus >= THERMAL_SEVERE -> "hot"
        level in 0 until MIN_LEVEL && !plugged -> "battery"
        sinceLastPollMs > IDLE_MS -> "left"
        elapsedMs >= minOf(durationMs, MAX_MS) -> "done"
        else -> null
    }
}
