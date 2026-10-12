package com.systemx.app.platform

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothManager
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.hardware.biometrics.BiometricPrompt
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.location.GnssStatus
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.media.AudioAttributes
import android.media.AudioDeviceInfo
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioRecord
import android.media.AudioTrack
import android.media.MediaRecorder
import android.os.Build
import android.os.CancellationSignal
import android.os.Handler
import android.os.Looper
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.view.WindowManager
import io.flutter.plugin.common.EventChannel
import java.util.concurrent.Executors

/**
 * Hardware actions for the diagnostics: tones, recording, vibration, torch,
 * brightness, the biometric prompt, Bluetooth state and saving a document.
 * Audio work runs on a background thread; results come back on the main one.
 */
class HardwareTestHost(private val activity: Activity) : HardwareTestApi {
    private val ctx: Context = activity.applicationContext
    private val audio = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private val am = ctx.getSystemService(AudioManager::class.java)
    private var clip: ShortArray? = null
    private var pendingSave: ((Result<Boolean>) -> Unit)? = null
    private var pendingBytes: ByteArray? = null

    override fun vibrate(pattern: List<Long>) {
        val timings = longArrayOf(0L) + pattern.toLongArray()
        val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            ctx.getSystemService(VibratorManager::class.java)?.defaultVibrator
        } else {
            @Suppress("DEPRECATION") ctx.getSystemService(Vibrator::class.java)
        } ?: return
        Sys.safe { vibrator.vibrate(VibrationEffect.createWaveform(timings, -1)) }
    }

    override fun hasVibrator(): Boolean {
        val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            ctx.getSystemService(VibratorManager::class.java)?.defaultVibrator
        } else {
            @Suppress("DEPRECATION") ctx.getSystemService(Vibrator::class.java)
        }
        return vibrator?.hasVibrator() == true
    }

    private fun torchCameraId(): String? {
        val cm = ctx.getSystemService(CameraManager::class.java) ?: return null
        return Sys.safe {
            cm.cameraIdList.firstOrNull { id ->
                cm.getCameraCharacteristics(id).get(CameraCharacteristics.FLASH_INFO_AVAILABLE) == true
            }
        }
    }

    override fun hasTorch(): Boolean = torchCameraId() != null

    override fun setTorch(on: Boolean): Boolean {
        val id = torchCameraId() ?: return false
        val cm = ctx.getSystemService(CameraManager::class.java) ?: return false
        return Sys.safe { cm.setTorchMode(id, on); true } ?: false
    }

    override fun setBrightness(level: Double) {
        val window = activity.window
        val attrs = window.attributes
        attrs.screenBrightness = if (level < 0) {
            WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
        } else level.toFloat().coerceIn(0.01f, 1f)
        window.attributes = attrs
    }

    override fun bluetoothState(): String {
        val adapter = Sys.safe { ctx.getSystemService(BluetoothManager::class.java)?.adapter } ?: return "none"
        return if (Sys.safe { adapter.isEnabled } == true) "on" else "off"
    }

    // ---- Audio ----

    private fun track(samples: ShortArray, earpiece: Boolean): AudioTrack {
        val usage = if (earpiece) AudioAttributes.USAGE_VOICE_COMMUNICATION else AudioAttributes.USAGE_MEDIA
        return AudioTrack.Builder()
            .setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(usage)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build(),
            )
            .setAudioFormat(
                AudioFormat.Builder()
                    .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                    .setSampleRate(RATE)
                    .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                    .build(),
            )
            .setTransferMode(AudioTrack.MODE_STATIC)
            .setBufferSizeInBytes(samples.size * 2)
            .build()
            .also { it.write(samples, 0, samples.size) }
    }

    /** Plays [samples] to the end, routed to the earpiece when asked. Blocks. */
    private fun playBlocking(samples: ShortArray, earpiece: Boolean) {
        val oldMode = am.mode
        if (earpiece) {
            am.mode = AudioManager.MODE_IN_COMMUNICATION
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                am.availableCommunicationDevices
                    .firstOrNull { it.type == AudioDeviceInfo.TYPE_BUILTIN_EARPIECE }
                    ?.let { am.setCommunicationDevice(it) }
            } else {
                @Suppress("DEPRECATION")
                am.isSpeakerphoneOn = false
            }
        }
        val t = track(samples, earpiece)
        try {
            t.play()
            Thread.sleep(samples.size * 1000L / RATE + 150)
            t.stop()
        } finally {
            t.release()
            if (earpiece) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) am.clearCommunicationDevice()
                am.mode = oldMode
            }
        }
    }

    private fun <T> runAudio(callback: (Result<T>) -> Unit, block: () -> T) {
        audio.execute {
            val result = try {
                Result.success(block())
            } catch (e: Throwable) {
                Result.failure(FlutterError("audio", e.message, null))
            }
            main.post { callback(result) }
        }
    }

    override fun playTone(freqHz: Double, durationMs: Long, earpiece: Boolean, callback: (Result<Unit>) -> Unit) =
        runAudio(callback) { playBlocking(AudioMath.sine(freqHz, durationMs.toInt(), RATE), earpiece) }

    private fun micGranted() =
        ctx.checkSelfPermission(Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED

    @Suppress("MissingPermission")
    private fun recorder(): AudioRecord {
        val min = AudioRecord.getMinBufferSize(RATE, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT)
        return AudioRecord(
            MediaRecorder.AudioSource.MIC, RATE, AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT, maxOf(min, RATE),
        )
    }

    /** Records [samples] fully, starting [onStarted] once audio is flowing. Blocks. */
    private fun recordInto(samples: ShortArray, onStarted: (() -> Unit)? = null) {
        val rec = recorder()
        try {
            check(rec.state == AudioRecord.STATE_INITIALIZED) { "microphone unavailable" }
            rec.startRecording()
            onStarted?.invoke()
            var read = 0
            while (read < samples.size) {
                val n = rec.read(samples, read, minOf(4096, samples.size - read))
                if (n <= 0) break
                read += n
            }
            rec.stop()
        } finally {
            rec.release()
        }
    }

    override fun recordClip(durationMs: Long, callback: (Result<Double>) -> Unit) = runAudio(callback) {
        check(micGranted()) { "no microphone permission" }
        val samples = ShortArray((RATE * durationMs / 1000).toInt())
        recordInto(samples)
        clip = samples
        AudioMath.peakDbfs(samples)
    }

    override fun playClip(callback: (Result<Unit>) -> Unit) = runAudio(callback) {
        clip?.let { playBlocking(it, earpiece = false) }
        Unit
    }

    override fun loopback(freqHz: Double, callback: (Result<Double>) -> Unit) = runAudio(callback) {
        check(micGranted()) { "no microphone permission" }
        val silenceMs = 500
        val toneMs = 1200
        val samples = ShortArray(RATE * (silenceMs + toneMs) / 1000)
        val tone = AudioMath.sine(freqHz, toneMs + 300, RATE, amplitude = 0.8)
        recordInto(samples) {
            Thread {
                Thread.sleep(silenceMs.toLong())
                Sys.safe { playBlocking(tone, earpiece = false) }
            }.start()
        }
        // Skip the first 100 ms of tone while the speaker starts.
        AudioMath.toneGainDb(samples, freqHz, RATE, RATE * (silenceMs + 100) / 1000)
    }

    // ---- Biometrics ----

    override fun authenticate(title: String, subtitle: String, cancel: String, callback: (Result<String>) -> Unit) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) return callback(Result.success("unavailable"))
        val executor = activity.mainExecutor
        var done = false
        fun finish(r: String) {
            if (!done) {
                done = true
                callback(Result.success(r))
            }
        }
        try {
            val prompt = BiometricPrompt.Builder(activity)
                .setTitle(title)
                .setSubtitle(subtitle)
                .setNegativeButton(cancel, executor) { _, _ -> finish("cancelled") }
                .build()
            prompt.authenticate(CancellationSignal(), executor, object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult?) = finish("success")
                override fun onAuthenticationError(errorCode: Int, errString: CharSequence?) = finish(
                    when (errorCode) {
                        BiometricPrompt.BIOMETRIC_ERROR_HW_NOT_PRESENT,
                        BiometricPrompt.BIOMETRIC_ERROR_HW_UNAVAILABLE -> "unavailable"
                        BiometricPrompt.BIOMETRIC_ERROR_NO_BIOMETRICS -> "none_enrolled"
                        else -> "cancelled"
                    },
                )
            })
        } catch (_: Throwable) {
            finish("unavailable")
        }
    }

    // ---- Stress test and display ----

    private val stress = StressRunner(ctx)

    override fun startStress(durationMs: Long): String? = stress.start(durationMs)

    override fun stressSample(): StressSample = stress.sample()

    override fun stopStress() = stress.stop()

    override fun keepScreenOn(on: Boolean) {
        if (on) {
            activity.window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        } else {
            activity.window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        }
    }

    /** Picks the fastest mode at the current resolution; 0 hands the choice back to the system. */
    override fun preferHighRefresh(high: Boolean) {
        val window = activity.window
        val attrs = window.attributes
        attrs.preferredDisplayModeId = if (high) {
            Sys.safe {
                @Suppress("DEPRECATION")
                val display = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) activity.display else activity.windowManager.defaultDisplay
                val cur = display?.mode
                display?.supportedModes
                    ?.filter { cur == null || (it.physicalWidth == cur.physicalWidth && it.physicalHeight == cur.physicalHeight) }
                    ?.maxByOrNull { it.refreshRate }?.modeId
            } ?: 0
        } else 0
        window.attributes = attrs
    }

    // ---- Saving the report ----

    override fun saveDocument(fileName: String, mimeType: String, bytes: ByteArray, callback: (Result<Boolean>) -> Unit) {
        if (pendingSave != null) return callback(Result.success(false))
        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT)
            .addCategory(Intent.CATEGORY_OPENABLE)
            .setType(mimeType)
            .putExtra(Intent.EXTRA_TITLE, fileName)
        try {
            pendingSave = callback
            pendingBytes = bytes
            activity.startActivityForResult(intent, SAVE_REQUEST)
        } catch (_: ActivityNotFoundException) {
            pendingSave = null
            pendingBytes = null
            callback(Result.success(false))
        }
    }

    /** Called from MainActivity.onActivityResult. */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != SAVE_REQUEST) return false
        val cb = pendingSave ?: return true
        val bytes = pendingBytes
        pendingSave = null
        pendingBytes = null
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null || bytes == null) {
            cb(Result.success(false))
            return true
        }
        val ok = Sys.safe {
            ctx.contentResolver.openOutputStream(uri)?.use { it.write(bytes) } != null
        } ?: false
        cb(Result.success(ok))
        return true
    }

    companion object {
        const val RATE = 48_000
        const val SAVE_REQUEST = 4108
    }
}

/**
 * Streams GNSS status while listened to: satellites seen, used in a fix,
 * and the fix accuracy. Needs Location permission; ends at once without it.
 */
class GnssStreamHandler(context: Context) : EventChannel.StreamHandler {
    private val ctx = context.applicationContext
    private val lm = ctx.getSystemService(LocationManager::class.java)
    private var sink: EventChannel.EventSink? = null
    private var seen = 0
    private var used = 0
    private var accuracy: Double? = null

    private val status = object : GnssStatus.Callback() {
        override fun onSatelliteStatusChanged(status: GnssStatus) {
            seen = status.satelliteCount
            used = (0 until status.satelliteCount).count { status.usedInFix(it) }
            emit()
        }
    }

    // All methods overridden: Android 9 and older have no defaults for them.
    private val listener = object : LocationListener {
        override fun onLocationChanged(loc: Location) {
            accuracy = if (loc.hasAccuracy()) loc.accuracy.toDouble() else null
            emit()
        }

        @Deprecated("Required on Android 9 and older")
        override fun onStatusChanged(provider: String?, status: Int, extras: android.os.Bundle?) = Unit
        override fun onProviderEnabled(provider: String) = Unit
        override fun onProviderDisabled(provider: String) = Unit
    }

    private fun emit() {
        sink?.success(mapOf("seen" to seen, "used" to used, "accuracy" to accuracy))
    }

    @Suppress("MissingPermission")
    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        if (ctx.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED ||
            lm == null || !lm.isProviderEnabled(LocationManager.GPS_PROVIDER)
        ) {
            events.endOfStream()
            return
        }
        sink = events
        seen = 0
        used = 0
        accuracy = null
        try {
            lm.registerGnssStatusCallback(status, Handler(Looper.getMainLooper()))
            lm.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000L, 0f, listener, Looper.getMainLooper())
            emit()
        } catch (_: SecurityException) {
            events.endOfStream()
            sink = null
        }
    }

    override fun onCancel(arguments: Any?) {
        Sys.safe { lm?.unregisterGnssStatusCallback(status) }
        Sys.safe { lm?.removeUpdates(listener) }
        sink = null
    }
}
