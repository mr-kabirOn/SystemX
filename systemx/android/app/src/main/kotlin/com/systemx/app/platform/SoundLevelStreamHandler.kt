package com.systemx.app.platform

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel

/**
 * Microphone level for the sound meter: one dBFS value about every 100 ms
 * while listened to. Nothing is recorded or kept; each block of samples is
 * reduced to one number and dropped. Ends at once without the microphone
 * permission or when the microphone is busy.
 */
class SoundLevelStreamHandler(context: Context) : EventChannel.StreamHandler {
    private val ctx = context.applicationContext
    private val main = Handler(Looper.getMainLooper())
    @Volatile private var running = false
    private var thread: Thread? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        if (ctx.checkSelfPermission(Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
            return events.endOfStream()
        }
        running = true
        thread = Thread({ loop(events) }, "sx-sound-meter").apply { isDaemon = true; start() }
    }

    override fun onCancel(arguments: Any?) {
        running = false
        thread = null
    }

    @Suppress("MissingPermission")
    private fun loop(events: EventChannel.EventSink) {
        val min = AudioRecord.getMinBufferSize(RATE, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT)
        // Voice recognition input skips most automatic gain control, so loud
        // and quiet rooms read differently, as a meter should.
        val rec = try {
            AudioRecord(
                MediaRecorder.AudioSource.VOICE_RECOGNITION, RATE, AudioFormat.CHANNEL_IN_MONO,
                AudioFormat.ENCODING_PCM_16BIT, maxOf(min, RATE / 5),
            )
        } catch (_: Exception) {
            main.post { events.endOfStream() }
            return
        }
        try {
            if (rec.state != AudioRecord.STATE_INITIALIZED) {
                main.post { events.endOfStream() }
                return
            }
            rec.startRecording()
            val block = ShortArray(RATE / 10) // 100 ms
            while (running) {
                val n = rec.read(block, 0, block.size)
                if (n <= 0) break
                val db = AudioMath.rmsDbfs(block, n)
                main.post { if (running) events.success(db) }
            }
        } catch (_: Exception) {
            main.post { events.endOfStream() }
        } finally {
            runCatching { rec.stop() }
            rec.release()
        }
    }

    private companion object {
        const val RATE = 44_100
    }
}
