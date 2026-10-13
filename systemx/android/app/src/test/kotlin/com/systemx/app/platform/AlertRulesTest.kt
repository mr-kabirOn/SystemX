package com.systemx.app.platform

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class AlertRulesTest {
    @Test
    fun chargeLimitOnlyWhileCharging() {
        assertTrue(AlertRules.chargeLimitReached(80, 80, charging = true))
        assertFalse(AlertRules.chargeLimitReached(79, 80, charging = true))
        assertFalse(AlertRules.chargeLimitReached(90, 80, charging = false))
    }

    @Test
    fun lowBatteryOnlyOnBattery() {
        assertTrue(AlertRules.batteryLow(15, 15, charging = false))
        assertFalse(AlertRules.batteryLow(15, 15, charging = true))
        assertFalse(AlertRules.batteryLow(-1, 15, charging = false))
    }

    @Test
    fun storageAndHeatThresholds() {
        assertTrue(AlertRules.storageFull(100, 9, 90))
        assertFalse(AlertRules.storageFull(100, 11, 90))
        assertFalse(AlertRules.storageFull(0, 0, 90))
        assertTrue(AlertRules.batteryHot(45.0, 45))
    }

    @Test
    fun cooldown() {
        assertTrue(AlertRules.cooldownOver(0, 1000, AlertRules.DAY))
        assertFalse(AlertRules.cooldownOver(1000, 2000, AlertRules.DAY))
        assertTrue(AlertRules.cooldownOver(1000, 1000 + AlertRules.DAY, AlertRules.DAY))
    }

    @Test
    fun statusIconShowsValueAndUnit() {
        assertEquals("78%" to "", AlertRules.statusIconLines("battery_level", 78, 33.4, false, 0.0))
        assertEquals("33°C" to "", AlertRules.statusIconLines("battery_temp", 78, 33.4, false, 0.0))
        assertEquals("92°F" to "", AlertRules.statusIconLines("battery_temp", 78, 33.4, true, 0.0))
        assertEquals("2.4" to "MB/s", AlertRules.statusIconLines("net_speed", 78, 33.4, false, 2_400_000.0))
        assertEquals("850" to "KB/s", AlertRules.rateParts(850_000.0))
        assertEquals("0" to "KB/s", AlertRules.rateParts(10.0))
        assertEquals("1.0" to "MB/s", AlertRules.rateParts(999_800.0))
        assertEquals("12" to "MB/s", AlertRules.rateParts(12_300_000.0))
    }

    @Test
    fun temperatureText() {
        assertEquals("33.1 °C", AlertRules.temp(33.1, false))
        assertEquals("91.6 °F", AlertRules.temp(33.1, true))
    }

    @Test
    fun byteRateHandlesResets() {
        assertEquals(2000.0, AlertRules.byteRate(1000, 3000, 0, 1000), 0.0)
        assertEquals(0.0, AlertRules.byteRate(5000, 1000, 0, 1000), 0.0)
    }
}
