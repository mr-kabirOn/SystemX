package com.systemx.app.platform

import android.content.Context
import android.os.Process
import android.os.SystemClock
import java.util.concurrent.atomic.AtomicLong
import kotlin.math.sqrt

/**
 * Loads every CPU core with plain arithmetic and counts how much work gets
 * done each second, so the screen can show whether the phone slows down as
 * it warms up. It touches no files, network or hardware besides the CPU.
 *
 * Safety lives here, not in the UI: a watchdog thread checks [StressRules]
 * every second and stops the workers on its own, including when the screen
 * stops polling because the app was closed or crashed.
 */
internal class StressRunner(context: Context) {
    private val ctx = context.applicationContext
    private val live = LiveProbe(ctx)
    private val work = AtomicLong()

    @Volatile private var running = false

    /** Bumped on every start, so threads from an earlier run always exit. */
    @Volatile private var generation = 0
    @Volatile private var stopReason: String? = null
    @Volatile private var lastPoll = 0L
    private var startedAt = 0L
    private var durationMs = 0L
    private var lastCount = 0L
    private var lastAt = 0L
    private var threads: List<Thread> = emptyList()

    @Synchronized
    fun start(durationMs: Long): String? {
        if (running) return null
        val s = live.live()
        StressRules.refuseStart(s.batteryTempC, s.batteryLevel.toInt(), s.plugged != 0L, s.thermalStatus.toInt())
            ?.let { return it }

        work.set(0)
        stopReason = null
        val gen = ++generation
        running = true
        this.durationMs = minOf(durationMs, StressRules.MAX_MS)
        startedAt = SystemClock.elapsedRealtime()
        lastPoll = startedAt
        lastAt = startedAt
        lastCount = 0

        val cores = Runtime.getRuntime().availableProcessors().coerceIn(1, 16)
        threads = List(cores) { i ->
            Thread({
                // Normal background priority: the UI and the system stay responsive.
                Process.setThreadPriority(Process.THREAD_PRIORITY_BACKGROUND)
                var x = 1.000001 + i
                while (running && generation == gen) {
                    for (k in 0 until 20_000) x = sqrt(x * 1.0000001 + k)
                    work.incrementAndGet()
                }
                if (x == 0.0) work.incrementAndGet() // keeps the loop from being optimised away
            }, "sx-stress-$i").apply { isDaemon = true; start() }
        }
        Thread({ watchdog(gen) }, "sx-stress-watchdog").apply { isDaemon = true; start() }
        return null
    }

    private fun watchdog(gen: Int) {
        while (running && generation == gen) {
            try {
                Thread.sleep(1_000)
            } catch (_: InterruptedException) {
                break
            }
            val now = SystemClock.elapsedRealtime()
            val s = try {
                live.live()
            } catch (_: Exception) {
                stop("error")
                return
            }
            StressRules.stopReason(
                elapsedMs = now - startedAt,
                durationMs = durationMs,
                batteryC = s.batteryTempC,
                level = s.batteryLevel.toInt(),
                plugged = s.plugged != 0L,
                thermalStatus = s.thermalStatus.toInt(),
                sinceLastPollMs = now - lastPoll,
            )?.let { stop(it) }
        }
    }

    @Synchronized
    fun sample(): StressSample {
        val now = SystemClock.elapsedRealtime()
        lastPoll = now
        val count = work.get()
        val rate = if (now > lastAt) (count - lastCount) * 1000.0 / (now - lastAt) else 0.0
        lastCount = count
        lastAt = now
        val s = live.live()
        return StressSample(
            elapsedMs = now - startedAt,
            workPerSec = rate,
            batteryTempC = s.batteryTempC,
            cpuTempC = s.cpuTempC,
            thermalStatus = s.thermalStatus,
            running = running,
            stopReason = stopReason,
        )
    }

    @Synchronized
    fun stop(reason: String = "user") {
        if (!running) return
        stopReason = reason
        running = false
        threads = emptyList()
    }
}
