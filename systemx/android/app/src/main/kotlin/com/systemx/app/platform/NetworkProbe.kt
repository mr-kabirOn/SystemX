package com.systemx.app.platform

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.location.LocationManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.wifi.WifiManager
import android.os.Build
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import java.net.Inet4Address
import java.net.Inet6Address

/** Active connection, Wi-Fi, mobile network and SIM cards. */
internal class NetworkProbe(private val ctx: Context) {

    private fun granted(permission: String) =
        ctx.checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED

    @SuppressLint("MissingPermission")
    fun network(): NetworkInfo {
        val cm = ctx.getSystemService(ConnectivityManager::class.java)
        val net = cm.activeNetwork
        val caps = net?.let { cm.getNetworkCapabilities(it) }
        val lp = net?.let { cm.getLinkProperties(it) }
        val tm = ctx.getSystemService(TelephonyManager::class.java)
        val wm = ctx.applicationContext.getSystemService(WifiManager::class.java)
        val phonePermission = granted(Manifest.permission.READ_PHONE_STATE)

        val transport = when {
            caps == null -> "none"
            caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "wifi"
            caps.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "cellular"
            caps.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> "ethernet"
            caps.hasTransport(NetworkCapabilities.TRANSPORT_VPN) -> "vpn"
            else -> "other"
        }

        val addresses = lp?.linkAddresses?.map { it.address } ?: emptyList()
        val gateway = lp?.routes?.firstOrNull { it.isDefaultRoute && it.gateway != null }
            ?.gateway?.hostAddress

        // Wi-Fi details. The network name needs Location permission and Location on.
        var ssid: String? = null
        var bssid: String? = null
        var rssi: Long? = null
        var link: Long? = null
        var tx: Long? = null
        var rx: Long? = null
        var freq: Long? = null
        var standard: Long? = null
        var needsLocation = false
        if (transport == "wifi") {
            @Suppress("DEPRECATION") val info = Sys.safe { wm.connectionInfo }
            if (info != null) {
                ssid = info.ssid?.trim('"')?.takeIf { it.isNotBlank() && it != WifiManager.UNKNOWN_SSID }
                bssid = info.bssid?.takeIf { it != "02:00:00:00:00:00" }
                rssi = info.rssi.toLong()
                link = info.linkSpeed.takeIf { it > 0 }?.toLong()
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    tx = info.txLinkSpeedMbps.takeIf { it > 0 }?.toLong()
                    rx = info.rxLinkSpeedMbps.takeIf { it > 0 }?.toLong()
                }
                freq = info.frequency.takeIf { it > 0 }?.toLong()
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    standard = info.wifiStandard.toLong()
                }
                needsLocation = ssid == null && (!granted(Manifest.permission.ACCESS_FINE_LOCATION) || !locationOn())
            }
        }

        val signal = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) Sys.safe { tm.signalStrength } else null

        return NetworkInfo(
            transport = transport,
            connected = caps != null,
            validated = caps?.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED) ?: false,
            metered = caps?.let { !it.hasCapability(NetworkCapabilities.NET_CAPABILITY_NOT_METERED) } ?: false,
            vpn = caps?.hasTransport(NetworkCapabilities.TRANSPORT_VPN) ?: false,
            downKbps = caps?.linkDownstreamBandwidthKbps?.takeIf { it > 0 }?.toLong(),
            upKbps = caps?.linkUpstreamBandwidthKbps?.takeIf { it > 0 }?.toLong(),
            iface = lp?.interfaceName,
            ipv4 = addresses.filterIsInstance<Inet4Address>().mapNotNull { it.hostAddress },
            ipv6 = addresses.filterIsInstance<Inet6Address>().mapNotNull { it.hostAddress?.substringBefore('%') },
            dns = lp?.dnsServers?.mapNotNull { it.hostAddress?.substringBefore('%') } ?: emptyList(),
            gateway = gateway,
            privateDns = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P && lp?.isPrivateDnsActive == true) {
                lp.privateDnsServerName ?: "Automatic"
            } else null,
            wifiEnabled = Sys.safe { wm.isWifiEnabled } ?: false,
            ssid = ssid,
            bssid = bssid,
            rssi = rssi,
            linkMbps = link,
            txMbps = tx,
            rxMbps = rx,
            freqMhz = freq,
            wifiStandard = standard,
            wifiNameNeedsLocation = needsLocation,
            operatorName = tm.networkOperatorName?.ifBlank { null },
            networkCountry = tm.networkCountryIso?.uppercase()?.ifBlank { null },
            roaming = Sys.safe { tm.isNetworkRoaming },
            signalLevel = signal?.level?.toLong(),
            signalDbm = signal?.cellSignalStrengths?.firstOrNull()?.dbm
                ?.takeIf { it != Int.MAX_VALUE && it < 0 }?.toLong(),
            dataNetworkType = if (phonePermission) Sys.safe { networkTypeName(tm.dataNetworkType) } else null,
            phonePermission = phonePermission,
        )
    }

    private fun locationOn(): Boolean {
        val lm = ctx.getSystemService(LocationManager::class.java) ?: return false
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) lm.isLocationEnabled
        else Sys.safe { lm.isProviderEnabled(LocationManager.GPS_PROVIDER) } ?: false
    }

    @SuppressLint("MissingPermission")
    fun sim(): SimInfo {
        val tm = ctx.getSystemService(TelephonyManager::class.java)
        val granted = granted(Manifest.permission.READ_PHONE_STATE)
        val slots = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) tm.activeModemCount
        else @Suppress("DEPRECATION") tm.phoneCount

        val cards = if (granted) Sys.safe {
            val sm = ctx.getSystemService(SubscriptionManager::class.java)
            val dataId = SubscriptionManager.getDefaultDataSubscriptionId()
            (sm.activeSubscriptionInfoList ?: emptyList()).map { s ->
                SimCard(
                    slot = (s.simSlotIndex + 1).toLong(),
                    carrier = s.carrierName?.toString()?.ifBlank { null },
                    displayName = s.displayName?.toString()?.ifBlank { null },
                    country = s.countryIso?.uppercase()?.ifBlank { null },
                    mcc = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) s.mccString
                    else @Suppress("DEPRECATION") s.mcc.toString(),
                    mnc = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) s.mncString
                    else @Suppress("DEPRECATION") s.mnc.toString(),
                    embedded = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) s.isEmbedded else false,
                    dataSim = s.subscriptionId == dataId,
                    networkType = Sys.safe {
                        networkTypeName(tm.createForSubscriptionId(s.subscriptionId).dataNetworkType)
                    },
                )
            }.sortedBy { it.slot }
        } ?: emptyList() else emptyList()

        return SimInfo(
            permissionGranted = granted,
            slotCount = slots.toLong(),
            simOperator = tm.simOperator?.ifBlank { null },
            simOperatorName = tm.simOperatorName?.ifBlank { null },
            country = tm.simCountryIso?.uppercase()?.ifBlank { null },
            simState = tm.simState.toLong(),
            cards = cards,
        )
    }

    private fun networkTypeName(type: Int): String? = when (type) {
        TelephonyManager.NETWORK_TYPE_NR -> "5G"
        TelephonyManager.NETWORK_TYPE_LTE -> "4G LTE"
        TelephonyManager.NETWORK_TYPE_HSPAP, TelephonyManager.NETWORK_TYPE_HSPA,
        TelephonyManager.NETWORK_TYPE_HSDPA, TelephonyManager.NETWORK_TYPE_HSUPA,
        TelephonyManager.NETWORK_TYPE_UMTS, TelephonyManager.NETWORK_TYPE_EVDO_0,
        TelephonyManager.NETWORK_TYPE_EVDO_A, TelephonyManager.NETWORK_TYPE_EVDO_B,
        TelephonyManager.NETWORK_TYPE_TD_SCDMA -> "3G"
        TelephonyManager.NETWORK_TYPE_EDGE, TelephonyManager.NETWORK_TYPE_GPRS,
        TelephonyManager.NETWORK_TYPE_CDMA, TelephonyManager.NETWORK_TYPE_1xRTT,
        TelephonyManager.NETWORK_TYPE_GSM -> "2G"
        TelephonyManager.NETWORK_TYPE_IWLAN -> "Wi-Fi calling"
        else -> null
    }
}
