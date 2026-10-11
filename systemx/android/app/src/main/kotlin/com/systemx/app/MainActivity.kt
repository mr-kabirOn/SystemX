package com.systemx.app

import android.content.Intent
import com.systemx.app.background.BackgroundBridge
import com.systemx.app.platform.BackgroundApi
import com.systemx.app.platform.BackgroundHost
import com.systemx.app.platform.DeviceInfoApi
import com.systemx.app.platform.DeviceInfoHost
import com.systemx.app.platform.GnssStreamHandler
import com.systemx.app.platform.HardwareTestApi
import com.systemx.app.platform.HardwareTestHost
import com.systemx.app.platform.PermissionApi
import com.systemx.app.platform.PermissionHost
import com.systemx.app.platform.SensorStreamHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private lateinit var permissions: PermissionHost
    private lateinit var hardware: HardwareTestHost

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        permissions = PermissionHost(this)
        hardware = HardwareTestHost(this)
        HardwareTestApi.setUp(messenger, hardware)
        EventChannel(messenger, "systemx/gnss").setStreamHandler(GnssStreamHandler(this))
        BackgroundApi.setUp(messenger, BackgroundHost(this))
        BackgroundBridge.onAppStart(this)
        DeviceInfoApi.setUp(messenger, DeviceInfoHost(this))
        PermissionApi.setUp(messenger, permissions)
        EventChannel(messenger, "systemx/sensor").setStreamHandler(SensorStreamHandler(this))
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        this.permissions.onResult(requestCode)
    }

    @Deprecated("FlutterActivity still delivers results here")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (::hardware.isInitialized && hardware.onActivityResult(requestCode, resultCode, data)) return
        @Suppress("DEPRECATION")
        super.onActivityResult(requestCode, resultCode, data)
    }
}
