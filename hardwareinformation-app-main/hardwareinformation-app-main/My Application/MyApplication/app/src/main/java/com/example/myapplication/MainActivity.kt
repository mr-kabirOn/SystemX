package com.example.myapplication

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import kotlinx.coroutines.*
import android.content.IntentFilter
import android.app.ActivityManager
import android.content.Context
import android.os.*
import android.telephony.TelephonyManager
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import java.io.File
import java.io.RandomAccessFile

import android.content.Intent

import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.wifi.WifiManager

import java.net.Inet4Address
import java.net.NetworkInterface

import android.telephony.SubscriptionManager
import java.util.Locale
import android.annotation.SuppressLint




class MainActivity : AppCompatActivity() {

    private lateinit var cpuInfoText: TextView
    private lateinit var ramInfoText: TextView
    private lateinit var storageInfoText: TextView
    private lateinit var batteryInfoText: TextView
    private lateinit var networkInfoText: TextView
    private lateinit var simInfoText: TextView
    private lateinit var balanceInfoText: TextView





    private var time = 0f

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activitymain)

        // Initialize the TextViews
        cpuInfoText = findViewById(R.id.cpuInfoText)
        ramInfoText = findViewById(R.id.ramInfoText)
        storageInfoText = findViewById(R.id.storageInfoText)
        batteryInfoText = findViewById(R.id.batteryInfoText)
        networkInfoText = findViewById(R.id.networkInfoText)
        simInfoText = findViewById(R.id.simInfoText)
        balanceInfoText = findViewById(R.id.balanceInfoText)





        // Button Click Listeners
        findViewById<Button>(R.id.btnCpu).setOnClickListener { fetchCpuInfo() }
        findViewById<Button>(R.id.btnRam).setOnClickListener { fetchRamInfo() }
        findViewById<Button>(R.id.btnStorage).setOnClickListener { fetchStorageInfo() }
        findViewById<Button>(R.id.btnBattery).setOnClickListener { showBatteryInfo() }
        findViewById<Button>(R.id.btnNetwork).setOnClickListener { showNetworkInfo() }
        findViewById<Button>(R.id.btnSim).setOnClickListener { showSimInfo() }
        findViewById<Button>(R.id.btnBalance).setOnClickListener { showBalanceInfo() }

        // Check runtime permissions
        checkPermissions()

        // Start real-time graph updates

    }




    private fun getCpuUsage(): Float {
        // Mock CPU usage for now
        return (10..90).random().toFloat()
    }

    private fun getRamUsage(): Float {
        val memInfo = ActivityManager.MemoryInfo()
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        activityManager.getMemoryInfo(memInfo)
        val usedRam = memInfo.totalMem - memInfo.availMem
        return (usedRam.toFloat() / memInfo.totalMem.toFloat()) * 100
    }

    private fun getStorageUsage(): Float {
        val path = File("/data")
        val stat = StatFs(path.path)
        val total = stat.blockCountLong * stat.blockSizeLong
        val free = stat.availableBlocksLong * stat.blockSizeLong
        return ((total - free).toFloat() / total.toFloat()) * 100
    }


    private fun fetchRamInfo() {
        CoroutineScope(Dispatchers.IO).launch {
            val ramInfo = getAccurateRamInfo()

            withContext(Dispatchers.Main) {
                ramInfoText.text = getString(
                    R.string.enhanced_ram_info,
                    ramInfo["total"],
                    ramInfo["used"],
                    ramInfo["free"],
                    ramInfo["percentage"]
                )
            }
        }
    }

    private fun getAccurateRamInfo(): Map<String, String> {
        var totalRamKB = 0L
        var freeRamKB = 0L
        var availableRamKB = 0L

        try {
            val reader = RandomAccessFile("/proc/meminfo", "r")
            var line: String?

            while (reader.readLine().also { line = it } != null) {
                if (line!!.startsWith("MemTotal:")) {
                    totalRamKB = line!!.split("\\s+".toRegex())[1].toLong()
                } else if (line!!.startsWith("MemFree:")) {
                    freeRamKB = line!!.split("\\s+".toRegex())[1].toLong()
                } else if (line!!.startsWith("MemAvailable:")) {
                    availableRamKB = line!!.split("\\s+".toRegex())[1].toLong()
                    break
                }
            }
            reader.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }

        // Convert to bytes for easier manipulation
        val totalRamBytes = totalRamKB * 1024
        val usedRamBytes = totalRamBytes - (availableRamKB * 1024)
        val freeRamBytes = availableRamKB * 1024

        // Convert to GB and MB for better readability
        val totalRamGB = totalRamBytes / (1024 * 1024 * 1024)
        val usedRamGB = usedRamBytes / (1024 * 1024 * 1024)
        val freeRamGB = freeRamBytes / (1024 * 1024 * 1024)

        val totalRamMB = totalRamBytes / (1024 * 1024)
        val usedRamMB = usedRamBytes / (1024 * 1024)
        val freeRamMB = freeRamBytes / (1024 * 1024)

        // Calculate the percentage of RAM used
        val percentageUsed = ((usedRamBytes.toDouble() / totalRamBytes.toDouble()) * 100).toInt()

        return mapOf(
            "total" to "$totalRamGB GB ($totalRamMB MB)",
            "used" to "$usedRamGB GB ($usedRamMB MB)",
            "free" to "$freeRamGB GB ($freeRamMB MB)",
            "percentage" to "$percentageUsed%"
        )
    }



    private fun fetchStorageInfo() {
        CoroutineScope(Dispatchers.IO).launch {
            val storageInfo = getEnhancedStorageInfo()

            withContext(Dispatchers.Main) {
                storageInfoText.text = getString(
                    R.string.enhanced_storage_info,
                    storageInfo["total"],
                    storageInfo["used"],
                    storageInfo["free"],
                    storageInfo["percentage"]
                )
            }
        }
    }
    private fun getEnhancedStorageInfo(): Map<String, String> {
        val path = File(Environment.getExternalStorageDirectory().path)
        val stat = StatFs(path.path)

        // Block size in bytes
        val blockSize = stat.blockSizeLong

        // Total, used, and available storage in bytes
        val totalBlocks = stat.blockCountLong
        val availableBlocks = stat.availableBlocksLong
        val totalStorage = totalBlocks * blockSize
        val freeStorage = availableBlocks * blockSize
        val usedStorage = totalStorage - freeStorage

        // Convert to GB
        val totalStorageGB = totalStorage / (1024 * 1024 * 1024)
        val freeStorageGB = freeStorage / (1024 * 1024 * 1024)
        val usedStorageGB = totalStorageGB - freeStorageGB

        // Calculate percentage used
        val percentageUsed = ((usedStorage.toDouble() / totalStorage.toDouble()) * 100).toInt()

        return mapOf(
            "total" to "$totalStorageGB GB",
            "used" to "$usedStorageGB GB",
            "free" to "$freeStorageGB GB",
            "percentage" to "$percentageUsed%"
        )
    }

    private val cpuUpdateInterval = 1000L // Update every 1 second
    private var isUpdatingCpuInfo = false

    private fun stopCpuUpdates() {
        isUpdatingCpuInfo = false
    }


    private fun getCpuInfo(): String {
        return try {
            val reader = RandomAccessFile("/proc/cpuinfo", "r")
            val line = reader.readLine() ?: "Unknown Processor"
            reader.close()
            line
        } catch (e: Exception) {
            "Unknown Processor"
        }
    }

    private fun getCpuManufacturer(): String {
        val cpuDetails = mutableMapOf<String, String>()

        try {
            val reader = RandomAccessFile("/proc/cpuinfo", "r")
            var line: String?

            while (reader.readLine().also { rawLine -> line = rawLine } != null) {
                val currentLine = line ?: continue // Make an immutable copy for safe access

                when {
                    currentLine.contains("Hardware") -> {
                        cpuDetails["Manufacturer"] = currentLine.split(":")[1].trim()
                    }
                    currentLine.contains("Processor") -> {
                        cpuDetails["Processor"] = currentLine.split(":")[1].trim()
                    }
                    currentLine.contains("model name", ignoreCase = true) -> {
                        cpuDetails["Model"] = currentLine.split(":")[1].trim()
                    }
                    currentLine.contains("CPU architecture", ignoreCase = true) -> {
                        cpuDetails["Architecture"] = currentLine.split(":")[1].trim()
                    }
                    currentLine.contains("CPU revision", ignoreCase = true) -> {
                        cpuDetails["Revision"] = currentLine.split(":")[1].trim()
                    }
                    currentLine.contains("vendor_id", ignoreCase = true) -> {
                        cpuDetails["Vendor ID"] = currentLine.split(":")[1].trim()
                    }
                }
            }

            reader.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }

        // Fallback values using Android APIs if /proc/cpuinfo lacks data
        val manufacturer = cpuDetails["Manufacturer"] ?: Build.MANUFACTURER
        val processor = cpuDetails["Processor"] ?: Build.HARDWARE
        val architecture = cpuDetails["Architecture"] ?: System.getProperty("os.arch") ?: "Unknown Architecture"
        val revision = cpuDetails["Revision"] ?: "Unknown Revision"
        val vendorId = cpuDetails["Vendor ID"] ?: "Unknown Vendor"

        return """
        Manufacturer: $manufacturer
        Processor: $processor
        Architecture: $architecture
        Revision: $revision
        Vendor ID: $vendorId
    """.trimIndent()
    }

    private fun getCpuCores(): Int {
        return try {
            File("/sys/devices/system/cpu/").listFiles { file ->
                file.isDirectory && file.name.matches(Regex("cpu[0-9]+"))
            }?.size ?: 1
        } catch (e: Exception) {
            1
        }
    }

    private fun getCpuFrequencies(): List<String> {
        val frequencies = mutableListOf<String>()
        val cores = getCpuCores()

        for (i in 0 until cores) {
            try {
                val freqPath = "/sys/devices/system/cpu/cpu$i/cpufreq/scaling_cur_freq"
                val maxFreqPath = "/sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_max_freq"
                val currentFreq = readFrequencyFile(freqPath)?.div(1000) ?: -1
                val maxFreq = readFrequencyFile(maxFreqPath)?.div(1000) ?: -1

                if (currentFreq == -1 || maxFreq == -1) {
                    frequencies.add("Core $i: Real-time frequency not available")
                } else {
                    frequencies.add("Core $i: Current: $currentFreq MHz, Max: $maxFreq MHz")
                }
            } catch (e: Exception) {
                frequencies.add("Core $i: Frequency not accessible")
            }
        }

        if (frequencies.isEmpty()) {
            frequencies.add("Dynamic frequency updates not supported on this device.")
        }

        return frequencies
    }


    private fun readFrequencyFile(path: String): Int? {
        return try {
            val reader = RandomAccessFile(path, "r")
            val frequency = reader.readLine().toIntOrNull()
            reader.close()
            frequency
        } catch (e: Exception) {
            null
        }
    }
    override fun onPause() {
        super.onPause()
        stopCpuUpdates() // Stop updates when the activity is not visible
    }

    override fun onResume() {
        super.onResume()
        fetchCpuInfo() // Resume updates when the activity becomes visible again
    }
    external fun getCpuFrequency(core: Int): String

    private fun fetchCpuInfo() {
        CoroutineScope(Dispatchers.IO).launch {
            val cpuInfo = getStaticCpuInfo()
            val cores = getCpuCores()
            val frequencies = getCpuFrequencies()
            val manufacturer = getCpuManufacturer()

            withContext(Dispatchers.Main) {
                cpuInfoText.text = """
                CPU Info: $cpuInfo
                Cores: $cores
                Frequencies:
                ${frequencies.joinToString("\n")}
                Manufacturer: $manufacturer
            """.trimIndent()
            }
        }
    }
    private fun getStaticCpuInfo(): String {
        val architecture = System.getProperty("os.arch") ?: "Unknown"
        val availableProcessors = Runtime.getRuntime().availableProcessors()
        return "Architecture: $architecture\nCores: $availableProcessors"
    }



    private fun getTotalRam(): Pair<String, String> {
        val memInfo = ActivityManager.MemoryInfo()
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        activityManager.getMemoryInfo(memInfo)
        val totalRam = memInfo.totalMem / (1024 * 1024 * 1024) // Convert bytes to GB
        return Pair("$totalRam GB", "${totalRam * 1024} MB")
    }

    private fun getStorageInfo(): Pair<String, String> {
        val stat = StatFs(Environment.getExternalStorageDirectory().path)
        val total = stat.blockCountLong * stat.blockSizeLong
        val totalStorage = total / (1024 * 1024 * 1024) // Convert bytes to GB
        return Pair("$totalStorage GB", "${totalStorage * 1024} MB")
    }

    private fun showBatteryInfo() {
        val batteryStatus = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))

        // Fetch battery level
        val level = batteryStatus?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1

        // Fetch battery health
        val health = when (batteryStatus?.getIntExtra(BatteryManager.EXTRA_HEALTH, -1)) {
            BatteryManager.BATTERY_HEALTH_GOOD -> "Good"
            BatteryManager.BATTERY_HEALTH_OVERHEAT -> "Overheat"
            BatteryManager.BATTERY_HEALTH_DEAD -> "Dead"
            BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "Over Voltage"
            BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "Failure"
            BatteryManager.BATTERY_HEALTH_COLD -> "Cold"
            else -> "Unknown"
        }

        // Fetch charging status
        val status = when (batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1)) {
            BatteryManager.BATTERY_STATUS_CHARGING -> "Charging"
            BatteryManager.BATTERY_STATUS_DISCHARGING -> "Discharging"
            BatteryManager.BATTERY_STATUS_FULL -> "Full"
            BatteryManager.BATTERY_STATUS_NOT_CHARGING -> "Not Charging"
            else -> "Unknown"
        }

        // Fetch battery voltage (in millivolts)
        val voltage = batteryStatus?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1) ?: -1
        val voltageInVolts = voltage / 1000.0 // Convert to volts for better readability

        // Fetch battery temperature (in tenths of a degree Celsius)
        val temperature = batteryStatus?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1) ?: -1
        val temperatureInCelsius = temperature / 10.0 // Convert to Celsius

        // Display battery information
        batteryInfoText.text = getString(
            R.string.battery_info,
            level,
            health,
            status,
            "%.1f V".format(voltageInVolts),
            "%.1f °C".format(temperatureInCelsius)
        )
    }


    private fun showNetworkInfo() {
        // Check if permissions are granted
        if (ContextCompat.checkSelfPermission(
                this,
                android.Manifest.permission.ACCESS_NETWORK_STATE
            ) != PackageManager.PERMISSION_GRANTED ||
            ContextCompat.checkSelfPermission(
                this,
                android.Manifest.permission.ACCESS_WIFI_STATE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            requestPermissions()
            return
        }

        val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val activeNetwork = connectivityManager.activeNetwork
        val networkCapabilities = connectivityManager.getNetworkCapabilities(activeNetwork)
        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

        var networkType = "No Connection"
        var wifiDetails = "Not Connected to Wi-Fi"
        var mobileDetails = "Not Connected to Mobile Data"
        var ipAddress = "Unavailable"

        if (networkCapabilities != null) {
            when {
                networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> {
                    networkType = "Wi-Fi"
                    val wifiInfo = wifiManager.connectionInfo
                    val ssid = wifiInfo.ssid.trim('"')
                    val rssi = wifiInfo.rssi
                    val ip = wifiInfo.ipAddress
                    ipAddress = formatIpAddress(ip)

                    wifiDetails = """
                    SSID: $ssid
                    Signal Strength: $rssi dBm
                    IP Address: $ipAddress
                """.trimIndent()
                }

                networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> {
                    networkType = "Mobile Data"
                    val carrierName = telephonyManager.networkOperatorName
                    val mobileNetworkType = when (telephonyManager.networkType) {
                        TelephonyManager.NETWORK_TYPE_LTE -> "4G LTE"
                        TelephonyManager.NETWORK_TYPE_NR -> "5G"
                        TelephonyManager.NETWORK_TYPE_HSPA,
                        TelephonyManager.NETWORK_TYPE_HSDPA,
                        TelephonyManager.NETWORK_TYPE_HSUPA -> "3G"
                        TelephonyManager.NETWORK_TYPE_EDGE -> "2G"
                        else -> "Unknown"
                    }
                    ipAddress = getMobileIpAddress() ?: "Unavailable"

                    mobileDetails = """
                    Carrier: $carrierName
                    Network Type: $mobileNetworkType
                    IP Address: $ipAddress
                """.trimIndent()
                }
            }
        }

        networkInfoText.text = """
        Network Type: $networkType
        Wi-Fi Details:
        $wifiDetails
        
        Mobile Network Details:
        $mobileDetails
    """.trimIndent()
    }

    private fun requestPermissions() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                android.Manifest.permission.ACCESS_NETWORK_STATE,
                android.Manifest.permission.ACCESS_WIFI_STATE,
                android.Manifest.permission.READ_PHONE_STATE
            ),
            100
        )
    }


    // Helper to format IP address from Wi-Fi
    private fun formatIpAddress(ip: Int): String {
        return String.format(
            "%d.%d.%d.%d",
            (ip and 0xff),
            (ip shr 8 and 0xff),
            (ip shr 16 and 0xff),
            (ip shr 24 and 0xff)
        )
    }

    // Helper to get the mobile network IP address
    private fun getMobileIpAddress(): String? {
        try {
            val interfaces = NetworkInterface.getNetworkInterfaces()
            while (interfaces.hasMoreElements()) {
                val networkInterface = interfaces.nextElement()
                val addresses = networkInterface.inetAddresses
                while (addresses.hasMoreElements()) {
                    val address = addresses.nextElement()
                    if (!address.isLoopbackAddress && address is Inet4Address) {
                        return address.hostAddress
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return null
    }

    @SuppressLint("MissingPermission")
    private fun showSimInfo() {
        // Check if the required permissions are granted
        if (ContextCompat.checkSelfPermission(
                this,
                android.Manifest.permission.READ_PHONE_STATE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            requestSimPermissions()
            return
        }

        val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

        // Initialize placeholders for SIM info
        val simInfoBuilder = StringBuilder()

        // If the device has multiple SIMs (API level 22+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            val subscriptionManager = getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
            val subscriptionList = subscriptionManager.activeSubscriptionInfoList

            if (!subscriptionList.isNullOrEmpty()) {
                for (subscriptionInfo in subscriptionList) {
                    val carrierName = subscriptionInfo.carrierName ?: "Unknown Carrier"
                    val countryCode = subscriptionInfo.countryIso?.uppercase(Locale.getDefault()) ?: "Unknown"
                    val slotIndex = subscriptionInfo.simSlotIndex + 1 // Slot index starts at 0
                    val phoneNumber = subscriptionInfo.number ?: "Unknown"

                    simInfoBuilder.append(
                        """
                    SIM Slot: $slotIndex
                    Carrier: $carrierName
                    Country Code: $countryCode
                    Phone Number: $phoneNumber
                    """.trimIndent()
                    ).append("\n\n")
                }
            } else {
                simInfoBuilder.append("No active SIMs found.")
            }
        } else {
            // Fallback for devices with no dual-SIM support or older Android versions
            val operatorName = telephonyManager.simOperatorName ?: "Unknown Carrier"
            val countryCode = telephonyManager.simCountryIso?.uppercase(Locale.getDefault()) ?: "Unknown"

            simInfoBuilder.append(
                """
            Carrier: $operatorName
            Country Code: $countryCode
            """.trimIndent()
            )
        }

        simInfoText.text = simInfoBuilder.toString()
    }

    private fun requestSimPermissions() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(android.Manifest.permission.READ_PHONE_STATE),
            200
        )
    }

    @SuppressLint("MissingPermission")
    private fun showBalanceInfo() {
        // Check if the required permissions are granted
        if (ContextCompat.checkSelfPermission(
                this,
                android.Manifest.permission.READ_PHONE_STATE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            requestBalancePermissions()
            return
        }

        val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

        val balanceInfoBuilder = StringBuilder()

        // If the device has multiple SIMs (API level 22+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
            val subscriptionManager = getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
            val subscriptionList = subscriptionManager.activeSubscriptionInfoList

            if (!subscriptionList.isNullOrEmpty()) {
                for (subscriptionInfo in subscriptionList) {
                    val carrierName = subscriptionInfo.carrierName.toString()
                    val slotIndex = subscriptionInfo.simSlotIndex + 1 // Slot index starts at 0

                    val balanceCode = when (carrierName) {
                        "Grameenphone" -> "*121#"
                        "Airtel" -> "*123#"
                        "Robi" -> "*222#"
                        "Banglalink" -> "*124#"
                        "Teletalk" -> "*152#"
                        else -> "Balance check code not available"
                    }

                    balanceInfoBuilder.append(
                        """
                    SIM Slot: $slotIndex
                    Carrier: $carrierName
                    Balance Code: $balanceCode
                    """.trimIndent()
                    ).append("\n\n")
                }
            } else {
                balanceInfoBuilder.append("No active SIMs found.")
            }
        } else {
            // Fallback for devices with no dual-SIM support or older Android versions
            val operatorName = telephonyManager.simOperatorName
            val balanceCode = when (operatorName) {
                "Grameenphone" -> "*121#"
                "Airtel" -> "*123#"
                "Robi" -> "*222#"
                "Banglalink" -> "*124#"
                "Teletalk" -> "*152#"
                else -> "Balance check code not available"
            }

            balanceInfoBuilder.append(
                """
            Carrier: $operatorName
            Balance Code: $balanceCode
            """.trimIndent()
            )
        }

        balanceInfoText.text = balanceInfoBuilder.toString()
    }

    private fun requestBalancePermissions() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(android.Manifest.permission.READ_PHONE_STATE),
            300
        )
    }


    private fun checkPermissions() {
        val permissions = listOf(
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.ACCESS_NETWORK_STATE,
            Manifest.permission.ACCESS_WIFI_STATE
        )

        val permissionsToRequest = permissions.filter {
            ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }

        if (permissionsToRequest.isNotEmpty()) {
            ActivityCompat.requestPermissions(this, permissionsToRequest.toTypedArray(), 100)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 100) {
            if (grantResults.any { it != PackageManager.PERMISSION_GRANTED }) {
                showPermissionDeniedMessage()
            }
        }
    }

    private fun showPermissionDeniedMessage() {
        Toast.makeText(this, "Permissions are required for the app to function.", Toast.LENGTH_LONG).show()
    }
}
