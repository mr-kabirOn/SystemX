package com.systemx.app.platform

import kotlin.math.PI
import kotlin.math.abs
import kotlin.math.cos
import kotlin.math.log10
import kotlin.math.max
import kotlin.math.sin

/** Pure audio helpers for the speaker and microphone tests (JVM unit tested). */
internal object AudioMath {
    /** A sine tone as 16-bit PCM, with short fades so it doesn't click. */
    fun sine(freqHz: Double, durationMs: Int, sampleRate: Int, amplitude: Double = 0.6): ShortArray {
        val n = (sampleRate.toLong() * durationMs / 1000).toInt()
        val fade = minOf(n / 2, sampleRate / 100) // 10 ms
        return ShortArray(n) { i ->
            val env = when {
                fade == 0 -> 1.0
                i < fade -> i.toDouble() / fade
                i > n - fade -> (n - i).toDouble() / fade
                else -> 1.0
            }
            (sin(2 * PI * freqHz * i / sampleRate) * amplitude * env * Short.MAX_VALUE).toInt().toShort()
        }
    }

    /** Power of one frequency in [samples] (Goertzel algorithm), normalised by length. */
    fun goertzel(samples: ShortArray, freqHz: Double, sampleRate: Int, from: Int = 0, to: Int = samples.size): Double {
        val n = to - from
        if (n <= 0) return 0.0
        val coeff = 2 * cos(2 * PI * freqHz / sampleRate)
        var s1 = 0.0
        var s2 = 0.0
        for (i in from until to) {
            val s0 = samples[i] / 32768.0 + coeff * s1 - s2
            s2 = s1
            s1 = s0
        }
        return (s1 * s1 + s2 * s2 - coeff * s1 * s2) / (n.toDouble() * n)
    }

    /** How much louder [freqHz] is during the tone than in the silence before it, in dB. */
    fun toneGainDb(samples: ShortArray, freqHz: Double, sampleRate: Int, silenceEnd: Int): Double {
        val quiet = goertzel(samples, freqHz, sampleRate, 0, silenceEnd)
        val tone = goertzel(samples, freqHz, sampleRate, silenceEnd, samples.size)
        return 10 * log10(max(tone, 1e-12) / max(quiet, 1e-12))
    }

    /** Peak level in dBFS (0 = full scale, about -90 = silence). */
    fun peakDbfs(samples: ShortArray): Double {
        var peak = 0
        for (s in samples) peak = max(peak, abs(s.toInt()))
        return if (peak == 0) -96.0 else 20 * log10(peak / 32768.0)
    }
}
