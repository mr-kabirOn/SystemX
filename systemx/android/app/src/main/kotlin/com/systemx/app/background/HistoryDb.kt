package com.systemx.app.background

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.systemx.app.platform.ChargeSession
import com.systemx.app.platform.HistorySample
import com.systemx.app.platform.SysParsers

/**
 * Battery, temperature and memory samples (kept 8 days) and charging
 * sessions (last 100), in a private app database.
 */
internal class HistoryDb private constructor(ctx: Context) :
    SQLiteOpenHelper(ctx, "history.db", null, 2) {

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL("CREATE TABLE samples (time INTEGER PRIMARY KEY, level INTEGER, temp REAL, mem REAL, charging INTEGER, screen INTEGER)")
        db.execSQL(
            "CREATE TABLE sessions (id INTEGER PRIMARY KEY AUTOINCREMENT, start INTEGER, end INTEGER, " +
                "start_level INTEGER, end_level INTEGER, peak_ma INTEGER, sum_ma INTEGER, n_ma INTEGER, max_temp REAL, " +
                "start_mah INTEGER, end_mah INTEGER)",
        )
    }

    /** Version 2 adds the screen state and the charge counter; old rows keep NULL. */
    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        if (oldVersion < 2) {
            db.execSQL("ALTER TABLE samples ADD COLUMN screen INTEGER")
            db.execSQL("ALTER TABLE sessions ADD COLUMN start_mah INTEGER")
            db.execSQL("ALTER TABLE sessions ADD COLUMN end_mah INTEGER")
        }
    }

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
                put("screen", if (r.screenOn) 1 else 0)
            },
            SQLiteDatabase.CONFLICT_REPLACE,
        )
        db.delete("samples", "time < ?", arrayOf((r.timeMs - 8 * 24 * 3_600_000L).toString()))
    }

    @Synchronized
    fun samples(sinceMs: Long): List<HistorySample> =
        readableDatabase.rawQuery(
            "SELECT time, level, temp, mem, charging, screen FROM samples WHERE time >= ? ORDER BY time",
            arrayOf(sinceMs.toString()),
        ).use { c ->
            buildList {
                while (c.moveToNext()) {
                    add(
                        HistorySample(
                            timeMs = c.getLong(0),
                            level = c.getLong(1),
                            tempC = c.getDouble(2),
                            memUsed = c.getDouble(3),
                            charging = c.getInt(4) == 1,
                            screenOn = if (c.isNull(5)) null else c.getInt(5) == 1,
                        ),
                    )
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
            r.chargeCounterMah?.let { put("start_mah", it) }
            r.chargeCounterMah?.let { put("end_mah", it) }
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
        r.chargeCounterMah?.let {
            sql.append(", end_mah = ?")
            args += it
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
            "SELECT start, end, start_level, end_level, peak_ma, sum_ma, n_ma, max_temp, start_mah, end_mah " +
                "FROM sessions ORDER BY start DESC LIMIT ?",
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
                            capacityMah = SysParsers.sessionCapacityMah(
                                if (c.isNull(8)) null else c.getLong(8),
                                if (c.isNull(9)) null else c.getLong(9),
                                c.getLong(2),
                                c.getLong(3),
                            ),
                        ),
                    )
                }
            }
        }

    /** Percentage points charged across the recorded sessions, and when the first began. */
    @Synchronized
    fun chargeAdded(): Pair<Long, Long>? =
        readableDatabase.rawQuery("SELECT SUM(MAX(end_level - start_level, 0)), MIN(start) FROM sessions", null).use { c ->
            if (c.moveToFirst() && !c.isNull(0) && !c.isNull(1)) c.getLong(0) to c.getLong(1) else null
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
