package com.systemx.app.platform

/**
 * Screen time from Android usage events, and an estimate of the battery each
 * app used. Pure, so it is unit tested; [ScreenTimeProbe] feeds it.
 *
 * Android doesn't share per-app battery use with apps, so it is estimated:
 * between two of SystemX's battery readings taken on battery, the drop is
 * split between apps by how long each was on screen in that interval. Time
 * with no app on screen (screen off, lock screen, launcher) keeps its share,
 * so app values are never inflated to fill the total.
 */
internal object ScreenTimeCalc {

    // UsageEvents.Event types. Screen and keyguard events are Android 9+.
    const val RESUMED = 1
    const val PAUSED = 2
    const val SCREEN_ON = 15
    const val SCREEN_OFF = 16
    const val UNLOCKED = 18
    const val STOPPED = 23
    const val SHUTDOWN = 26

    /** Readings further apart than this are too coarse to split. */
    const val MAX_GAP_MS = 2 * 3_600_000L

    /** [cls] is the activity class; null when unknown. */
    data class Ev(val t: Long, val type: Int, val pkg: String?, val cls: String? = null)
    data class Span(val pkg: String, val start: Long, val end: Long)
    data class Level(val t: Long, val level: Int, val charging: Boolean)

    data class App(val pkg: String, val ms: Long, val opens: Int, val battery: Double?)
    data class Day(
        val start: Long,
        val screenMs: Long,
        val unlocks: Int?,
        val drain: Int?,
        val screenDrain: Double?,
        val apps: List<App>,
    )

    /**
     * Foreground spans and app opens. A span ends when another app comes up,
     * the activity on screen pauses or stops, or the screen turns off; spans
     * still open end at [to].
     *
     * Android logs A paused, B resumed, then A stopped. When A and B are
     * screens of the same app, A's late "stopped" must not end B's time, so
     * pause/stop only count for the activity that is on screen.
     */
    fun foreground(events: List<Ev>, to: Long): Pair<List<Span>, List<Ev>> {
        val spans = mutableListOf<Span>()
        val opens = mutableListOf<Ev>()
        var cur: String? = null
        var curCls: String? = null
        var since = 0L
        var last: String? = null // last app on screen, kept across pauses
        fun close(t: Long) {
            val p = cur ?: return
            if (t > since) spans += Span(p, since, t)
            cur = null
        }
        for (e in events) when (e.type) {
            RESUMED -> {
                val p = e.pkg ?: continue
                if (cur != p) {
                    close(e.t)
                    cur = p
                    since = e.t
                }
                curCls = e.cls
                if (last != p) opens += e
                last = p
            }
            PAUSED, STOPPED -> if (e.pkg == cur && (e.cls == null || curCls == null || e.cls == curCls)) close(e.t)
            SCREEN_OFF, SHUTDOWN -> {
                close(e.t)
                last = null
            }
        }
        close(to)
        return spans to opens
    }

    /**
     * Screen-on spans, or null when there are no screen events (Android 8).
     * If the first event turns the screen off, it was on from [from].
     */
    fun screen(events: List<Ev>, from: Long, to: Long): List<LongArray>? {
        val marks = events.filter { it.type == SCREEN_ON || it.type == SCREEN_OFF || it.type == SHUTDOWN }
        if (marks.none { it.type != SHUTDOWN }) return null
        val spans = mutableListOf<LongArray>()
        var on: Long? = if (marks.first().type == SCREEN_OFF) from else null
        for (m in marks) {
            if (m.type == SCREEN_ON) {
                if (on == null) on = m.t
            } else {
                on?.let { if (m.t > it) spans += longArrayOf(it, m.t) }
                on = null
            }
        }
        on?.let { if (to > it) spans += longArrayOf(it, to) }
        return spans
    }

    fun overlap(s: Long, e: Long, a: Long, b: Long): Long = (minOf(e, b) - maxOf(s, a)).coerceAtLeast(0)

    /**
     * One [Day] per entry in [dayStarts] (sorted local midnights); a day ends
     * at the next start, or 24 h later for the last one, capped at [now].
     * Apps in [exclude] (launchers, system UI) count toward screen time but
     * are not listed.
     */
    fun days(
        dayStarts: List<Long>,
        now: Long,
        events: List<Ev>,
        levels: List<Level>,
        exclude: Set<String>,
    ): List<Day> {
        val sorted = events.sortedBy { it.t }
        val (spans, opens) = foreground(sorted, now)
        val screen = screen(sorted, dayStarts.firstOrNull() ?: now, now)
        val hasScreenEvents = screen != null
        val listed = spans.filter { it.pkg !in exclude }

        // Battery split per reading interval, attributed to each app and day.
        val appBattery = HashMap<Pair<Int, String>, Double>()
        val dayDrain = HashMap<Int, Int>()
        val dayScreenDrain = HashMap<Int, Double>()
        fun dayOf(t: Long): Int = dayStarts.indexOfLast { it <= t }
        val lv = levels.sortedBy { it.t }
        for (i in 1 until lv.size) {
            val a = lv[i - 1]
            val b = lv[i]
            val gap = b.t - a.t
            if (a.charging || b.charging || gap <= 0 || gap > MAX_GAP_MS) continue
            val drop = a.level - b.level
            if (drop <= 0) continue
            val day = dayOf(a.t + gap / 2)
            if (day < 0) continue
            dayDrain[day] = (dayDrain[day] ?: 0) + drop
            val onMs = screen?.sumOf { overlap(it[0], it[1], a.t, b.t) }
                ?: spans.sumOf { overlap(it.start, it.end, a.t, b.t) }
            dayScreenDrain[day] = (dayScreenDrain[day] ?: 0.0) + drop * onMs.toDouble() / gap
            for (s in listed) {
                val ms = overlap(s.start, s.end, a.t, b.t)
                if (ms == 0L) continue
                val key = day to s.pkg
                appBattery[key] = (appBattery[key] ?: 0.0) + drop * ms.toDouble() / gap
            }
        }
        // Days SystemX has readings for: at least one reading within the day.
        val covered = lv.map { dayOf(it.t) }.toSet()

        return dayStarts.mapIndexed { i, start ->
            val end = minOf(dayStarts.getOrNull(i + 1) ?: (start + 24 * 3_600_000L), now)
            val perApp = HashMap<String, Long>()
            for (s in listed) {
                val ms = overlap(s.start, s.end, start, end)
                if (ms > 0) perApp[s.pkg] = (perApp[s.pkg] ?: 0L) + ms
            }
            val opensIn = opens.filter { it.t in start until end && it.pkg !in exclude }
                .groupingBy { it.pkg!! }.eachCount()
            val screenMs = screen?.sumOf { overlap(it[0], it[1], start, end) }
                ?: spans.sumOf { overlap(it.start, it.end, start, end) }
            val hasBattery = i in covered
            Day(
                start = start,
                screenMs = screenMs,
                unlocks = if (hasScreenEvents) sorted.count { it.type == UNLOCKED && it.t in start until end } else null,
                drain = if (hasBattery) dayDrain[i] ?: 0 else null,
                screenDrain = if (hasBattery) dayScreenDrain[i] ?: 0.0 else null,
                apps = perApp.entries
                    .map { (p, ms) ->
                        App(p, ms, opensIn[p] ?: 0, if (hasBattery) appBattery[i to p] ?: 0.0 else null)
                    }
                    .sortedWith(compareByDescending<App> { it.ms }.thenBy { it.pkg }),
            )
        }
    }
}
