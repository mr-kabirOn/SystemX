package com.systemx.app.platform

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class StressRulesTest {
    private fun stop(
        elapsed: Long = 10_000,
        duration: Long = 60_000,
        temp: Double = 35.0,
        level: Int = 80,
        plugged: Boolean = false,
        thermal: Int = 0,
        idle: Long = 1_000,
    ) = StressRules.stopReason(elapsed, duration, temp, level, plugged, thermal, idle)

    @Test
    fun keepsGoingWhenAllIsWell() = assertNull(stop())

    @Test
    fun stopsAtEachLimit() {
        assertEquals("hot", stop(temp = 45.0))
        assertEquals("hot", stop(thermal = 3))
        assertEquals("battery", stop(level = 14))
        assertEquals("left", stop(idle = 6_000))
        assertEquals("done", stop(elapsed = 60_000))
        // Never longer than the hard cap, whatever was asked.
        assertEquals("done", stop(elapsed = 180_000, duration = 600_000))
    }

    @Test
    fun lowBatteryIsFineWhilePluggedIn() = assertNull(stop(level = 10, plugged = true))

    @Test
    fun refusesToStartWhenAlreadyWarmOrLow() {
        assertEquals("hot", StressRules.refuseStart(42.5, 80, false, 0))
        assertEquals("hot", StressRules.refuseStart(35.0, 80, false, 2))
        assertEquals("battery", StressRules.refuseStart(35.0, 19, false, 0))
        assertNull(StressRules.refuseStart(35.0, 19, true, 0))
        assertNull(StressRules.refuseStart(35.0, 80, false, 1))
    }
}
