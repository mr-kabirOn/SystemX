package com.systemx.app

import com.systemx.app.platform.DeviceInfoApi
import com.systemx.app.platform.DeviceInfoHost
import com.systemx.app.platform.PermissionApi
import com.systemx.app.platform.PermissionHost
import com.systemx.app.platform.SensorStreamHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private lateinit var permissions: PermissionHost

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        permissions = PermissionHost(this)
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
}
