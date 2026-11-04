package com.systemx.app.platform

import com.systemx.app.platform.DataUsageCalc.Bucket
import org.junit.Assert.assertEquals
import org.junit.Test

class DataUsageCalcTest {
    private val names = mapOf(10100 to "com.whatsapp", 10200 to "com.android.chrome")

    @Test
    fun groupsUidsIntoAppsAndSystemBuckets() {
        val rows = DataUsageCalc.group(
            listOf(
                Bucket(10100, 500, 100),
                Bucket(10100, 300, 50), // same app, another bucket
                Bucket(10200, 2_000, 200),
                Bucket(1000, 40, 10), // Android system
                Bucket(DataUsageCalc.UID_REMOVED, 70, 0),
                Bucket(DataUsageCalc.UID_TETHERING, 900, 100),
                Bucket(10999, 5, 5), // Android won't name it
                Bucket(10300, 0, 0), // nothing used
            ),
        ) { names[it] }
        assertEquals(listOf("com.android.chrome", "tethering", "com.whatsapp", "removed", "system", "other"), rows.map { it.key })
        val whatsapp = rows.first { it.key == "com.whatsapp" }
        assertEquals(800L, whatsapp.rx)
        assertEquals(150L, whatsapp.tx)
        assertEquals("app", whatsapp.kind)
        assertEquals("system", rows.first { it.key == "system" }.kind)
    }
}
