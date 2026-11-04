package com.systemx.app.platform

/**
 * Groups Android's per-UID network buckets into rows: one per app, plus
 * system, removed apps, tethering and apps Android doesn't name. Pure, so
 * it is unit tested; [DataUsageProbe] feeds it.
 */
internal object DataUsageCalc {
    /** NetworkStats.Bucket.UID_REMOVED / UID_TETHERING. */
    const val UID_REMOVED = -4
    const val UID_TETHERING = -5

    /** Below this UID are Android's own system processes. */
    const val FIRST_APP_UID = 10_000

    data class Bucket(val uid: Int, val rx: Long, val tx: Long)
    data class Row(val key: String, val kind: String, val rx: Long, val tx: Long) {
        val total get() = rx + tx
    }

    /** [packageOf] names a UID's app, or null when Android won't say. */
    fun group(buckets: List<Bucket>, packageOf: (Int) -> String?): List<Row> {
        val rows = LinkedHashMap<String, Row>()
        for (b in buckets) {
            if (b.rx + b.tx <= 0) continue
            val (key, kind) = when {
                b.uid == UID_REMOVED -> "removed" to "removed"
                b.uid == UID_TETHERING -> "tethering" to "tethering"
                b.uid in 0 until FIRST_APP_UID -> "system" to "system"
                else -> packageOf(b.uid)?.let { it to "app" } ?: ("other" to "other")
            }
            val prev = rows[key]
            rows[key] = if (prev == null) Row(key, kind, b.rx, b.tx) else prev.copy(rx = prev.rx + b.rx, tx = prev.tx + b.tx)
        }
        return rows.values.sortedWith(compareByDescending<Row> { it.total }.thenBy { it.key })
    }
}
