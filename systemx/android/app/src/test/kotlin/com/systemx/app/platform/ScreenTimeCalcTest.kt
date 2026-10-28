package com.systemx.app.platform

import com.systemx.app.platform.ScreenTimeCalc.Ev
import com.systemx.app.platform.ScreenTimeCalc.Level
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class ScreenTimeCalcTest {
    private val min = 60_000L
    private val hour = 60 * min
    private val day0 = 0L
    private val day1 = 24 * hour

    private fun on(t: Long) = Ev(t, ScreenTimeCalc.SCREEN_ON, null)
    private fun off(t: Long) = Ev(t, ScreenTimeCalc.SCREEN_OFF, null)
    private fun unlock(t: Long) = Ev(t, ScreenTimeCalc.UNLOCKED, null)
    private fun up(t: Long, p: String) = Ev(t, ScreenTimeCalc.RESUMED, p)
    private fun down(t: Long, p: String) = Ev(t, ScreenTimeCalc.PAUSED, p)

    @Test
    fun countsForegroundTimeAndOpens() {
        val events = listOf(
            on(hour), unlock(hour), up(hour, "a"), down(hour + 10 * min, "a"),
            up(hour + 10 * min, "b"), down(hour + 30 * min, "b"),
            up(hour + 30 * min, "a"), off(hour + 40 * min),
        )
        val d = ScreenTimeCalc.days(listOf(day0), 2 * hour, events, emptyList(), emptySet()).single()
        assertEquals(40 * min, d.screenMs)
        assertEquals(1, d.unlocks)
        assertEquals(listOf("a", "b"), d.apps.map { it.pkg }) // 20 min each, then by name
        assertEquals(20 * min, d.apps[0].ms)
        assertEquals(2, d.apps.first { it.pkg == "a" }.opens)
        assertNull(d.drain)
        assertNull(d.apps[0].battery)
    }

    @Test
    fun activitySwitchInsideAnAppIsOneOpen() {
        val events = listOf(on(0), up(min, "a"), down(2 * min, "a"), up(2 * min, "a"), off(5 * min))
        val d = ScreenTimeCalc.days(listOf(day0), hour, events, emptyList(), emptySet()).single()
        assertEquals(1, d.apps.single().opens)
        assertEquals(4 * min, d.apps.single().ms)
    }

    @Test
    fun splitsSpansAcrossMidnight() {
        val events = listOf(on(day1 - 30 * min), up(day1 - 30 * min, "a"), off(day1 + 15 * min))
        val days = ScreenTimeCalc.days(listOf(day0, day1), day1 + hour, events, emptyList(), emptySet())
        assertEquals(30 * min, days[0].apps.single().ms)
        assertEquals(15 * min, days[1].apps.single().ms)
        assertEquals(15 * min, days[1].screenMs)
    }

    @Test
    fun openSpanEndsNowAndScreenOnBeforeRange() {
        // The first screen event turns it off, so it was on from the start.
        val events = listOf(off(30 * min), on(hour), up(hour, "a"))
        val d = ScreenTimeCalc.days(listOf(day0), hour + 20 * min, events, emptyList(), emptySet()).single()
        assertEquals(50 * min, d.screenMs)
        assertEquals(20 * min, d.apps.single().ms)
    }

    @Test
    fun excludedAppsCountForScreenTimeButAreNotListed() {
        val events = listOf(on(0), up(0, "launcher"), up(10 * min, "a"), off(20 * min))
        val d = ScreenTimeCalc.days(listOf(day0), hour, events, emptyList(), setOf("launcher")).single()
        assertEquals(20 * min, d.screenMs)
        assertEquals(listOf("a"), d.apps.map { it.pkg })
    }

    @Test
    fun withoutScreenEventsUsesForegroundTime() {
        val events = listOf(up(0, "a"), down(10 * min, "a"))
        val d = ScreenTimeCalc.days(listOf(day0), hour, events, emptyList(), emptySet()).single()
        assertEquals(10 * min, d.screenMs)
        assertNull(d.unlocks)
    }

    @Test
    fun splitsBatteryDropByTimeOnScreen() {
        // 0–60 min: 10 points dropped; "a" on screen 30 min, screen off the rest.
        val events = listOf(on(0), up(0, "a"), off(30 * min))
        val levels = listOf(Level(0, 80, false), Level(hour, 70, false))
        val d = ScreenTimeCalc.days(listOf(day0), 2 * hour, events, levels, emptySet()).single()
        assertEquals(10, d.drain)
        assertEquals(5.0, d.apps.single().battery!!, 1e-9)
        assertEquals(5.0, d.screenDrain!!, 1e-9)
    }

    @Test
    fun ignoresChargingAndLongGaps() {
        val events = listOf(on(0), up(0, "a"))
        val levels = listOf(
            Level(0, 50, false), Level(hour, 60, true), // charging
            Level(2 * hour, 58, false), Level(5 * hour, 40, false), // 3 h gap
        )
        val d = ScreenTimeCalc.days(listOf(day0), 6 * hour, events, levels, emptySet()).single()
        assertEquals(0, d.drain)
        assertEquals(0.0, d.apps.single().battery!!, 1e-9)
    }

    @Test
    fun aLateStopOfThePreviousScreenDoesNotEndTheApp() {
        // Inside one app: A paused, B resumed, then A stopped (Android's order).
        val events = listOf(
            on(0),
            Ev(0, ScreenTimeCalc.RESUMED, "a", "A"),
            Ev(10 * min, ScreenTimeCalc.PAUSED, "a", "A"),
            Ev(10 * min, ScreenTimeCalc.RESUMED, "a", "B"),
            Ev(10 * min + 500, ScreenTimeCalc.STOPPED, "a", "A"),
            off(30 * min),
        )
        val d = ScreenTimeCalc.days(listOf(day0), hour, events, emptyList(), emptySet()).single()
        assertEquals(30 * min, d.apps.single().ms)
        assertEquals(1, d.apps.single().opens)
    }

    @Test
    fun newChargeWhenLevelFellAcrossAGapOrChargerChanged() {
        assertEquals(true, SessionRules.isNewCharge(80, 70, 0, 1, null))
        assertEquals(true, SessionRules.isNewCharge(80, 70, 1, 1, 10 * min))
        assertEquals(false, SessionRules.isNewCharge(80, 70, 1, 1, 2_000)) // weak charger, continuous readings
        assertEquals(true, SessionRules.isNewCharge(80, 81, 1, 4, 2_000)) // USB to wireless
        assertEquals(false, SessionRules.isNewCharge(80, 79, 1, 1, null)) // 1 point is noise
    }
}
