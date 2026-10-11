package com.systemx.app.platform

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class AudioMathTest {
    private val rate = 48_000

    @Test
    fun sineHasTheRequestedLengthAndFades() {
        val s = AudioMath.sine(1000.0, 500, rate)
        assertEquals(24_000, s.size)
        assertEquals(0, s[0].toInt())
        assertTrue(AudioMath.peakDbfs(s) > -6)
    }

    @Test
    fun goertzelFindsTheToneFrequency() {
        val s = AudioMath.sine(1000.0, 300, rate)
        val at = AudioMath.goertzel(s, 1000.0, rate)
        val off = AudioMath.goertzel(s, 3000.0, rate)
        assertTrue(at > off * 1000)
    }

    @Test
    fun toneGainComparesToneWithSilence() {
        val silence = ShortArray(rate / 2) { ((it * 7919) % 41 - 20).toShort() } // faint noise
        val tone = AudioMath.sine(1000.0, 1000, rate, amplitude = 0.3)
        val heard = AudioMath.toneGainDb(silence + tone, 1000.0, rate, silence.size)
        val missed = AudioMath.toneGainDb(silence + silence, 1000.0, rate, silence.size)
        assertTrue("heard $heard", heard > 30)
        assertTrue("missed $missed", missed < 10)
    }

    @Test
    fun peakOfSilenceIsTheFloor() {
        assertEquals(-96.0, AudioMath.peakDbfs(ShortArray(100)), 0.0)
    }
}
