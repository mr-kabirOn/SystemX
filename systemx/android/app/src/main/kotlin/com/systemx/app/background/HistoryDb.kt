package com.systemx.app.background

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.systemx.app.platform.ChargeSession
import com.systemx.app.platform.HistorySample

/**
 * Battery, temperature and memory samples (kept 8 days) and charging
 * sessions (last 100), in a private app database.
 */
internal class HistoryDb private constructor(ctx: Context) :
    SQLiteOpenHelper(ctx, "history.db", null, 1) {

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL("CREATE TABLE samples (time INTEGER PRIMARY KEY, level INTEGER, temp REAL, mem REAL, charging INTEGER)")
        db.execSQL(
            "CREATE TABLE sessions (id INTEGER PRIMARY KEY AUTOINCREMENT, start INTEGER, end INTEGER, " +
                "start_level INTEGER, end_level INTEGER, peak_ma INTEGER, sum_ma INTEGER, n_ma INTEGER, max_temp REAL)",
        )
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) = Unit

    @Synchronized
    fun lastSampleTime(): Long = readableDatabase.rawQuery("SELECT MAX(time) FROM samples", null).use { c ->
        if (c.moveToFirst() && !c.isNull(0)) c.getLong(0) else 0L
    }

    @Synchronized
    fun addSample(r: Reading) {
        val db = writableDatabase
        db.insertWithOnConflict(
            "samples", null,
            ContentValues().apply {
                put("time", r.timeMs)
                put("level", r.level)
                put("temp", r.tempC)
                put("mem", r.memUsed)
                put("charging", if (r.pluggedIn) 1 else 0)
            },
            SQLiteDatabase.CONFLICT_REPLACE,
        )
        db.delete("samples", "time < ?", arrayOf((r.timeMs - 8 * 24 * 3_600_000L).toString()))
    }

    @Synchronized
    fun samples(sinceMs: Long): List<HistorySample> =
        readableDatabase.rawQuery(
            "SELECT time, level, temp, mem, charging FROM samples WHERE time >= ? ORDER BY time",
            arrayOf(sinceMs.toString()),
        ).use { c ->
            buildList {
                while (c.moveToNext()) {
                    add(HistorySample(c.getLong(0), c.getLong(1), c.getDouble(2), c.getDouble(3), c.getInt(4) == 1))
                }
            }
        }

    /** Id and start time of the session still open, if any. */
    @Synchronized
    fun openSession(): Pair<Long, Long>? =
        readableDatabase.rawQuery("SELECT id, start FROM sessions WHERE end IS NULL ORDER BY id DESC LIMIT 1", null)
            .use { c -> if (c.moveToFirst()) c.getLong(0) to c.getLong(1) else null }

    @Synchronized
    fun startSession(r: Reading): Long = writableDatabase.insert(
        "sessions", null,
        ContentValues().apply {
            put("start", r.timeMs)
            put("start_level", r.level)
            put("end_level", r.level)
            put("peak_ma", r.currentMa?.takeIf { it > 0 } ?: 0)
            put("sum_ma", r.currentMa?.takeIf { it > 0 } ?: 0)
            put("n_ma", if ((r.currentMa ?: 0) > 0) 1 else 0)
            put("max_temp", r.tempC)
        },
    )

    @Synchronized
    fun updateSession(id: Long, r: Reading, close: Boolean) {
        val ma = r.currentMa?.takeIf { it > 0 }
        val sql = StringBuilder("UPDATE sessions SET end_level = ?, max_temp = MAX(max_temp, ?)")
        val args = mutableListOf<Any>(r.level, r.tempC)
        if (ma != null) {
            sql.append(", peak_ma = MAX(peak_ma, ?), sum_ma = sum_ma + ?, n_ma = n_ma + 1")
            args += ma
            args += ma
        }
        if (close) {
            sql.append(", end = ?")
            args += r.timeMs
        }
        sql.append(" WHERE id = ?")
        args += id
        writableDatabase.execSQL(sql.toString(), args.toTypedArray())
    }

    @Synchronized
    fun sessions(limit: Int): List<ChargeSession> =
        readableDatabase.rawQuery(
            "SELECT start, end, start_level, end_level, peak_ma, sum_ma, n_ma, max_temp FROM sessions ORDER BY start DESC LIMIT ?",
            arrayOf(limit.toString()),
        ).use { c ->
            buildList {
                while (c.moveToNext()) {
                    val n = c.getLong(6)
                    add(
                        ChargeSession(
                            startMs = c.getLong(0),
                            endMs = if (c.isNull(1)) null else c.getLong(1),
                            startLevel = c.getLong(2),
                            endLevel = c.getLong(3),
                            peakMa = c.getLong(4).takeIf { it > 0 },
                            avgMa = if (n > 0) c.getLong(5) / n else null,
                            maxTempC = c.getDouble(7),
                        ),
                    )
                }
            }
        }

    @Synchronized
    fun pruneSessions() {
        writableDatabase.execSQL("DELETE FROM sessions WHERE id NOT IN (SELECT id FROM sessions ORDER BY start DESC LIMIT 100)")
    }

    @Synchronized
    fun clear() {
        writableDatabase.delete("samples", null, null)
        writableDatabase.delete("sessions", null, null)
    }

    companion object {
        @Volatile
        private var instance: HistoryDb? = null

        fun get(ctx: Context): HistoryDb = instance ?: synchronized(this) {
            instance ?: HistoryDb(ctx.applicationContext).also { instance = it }
        }
    }
}
