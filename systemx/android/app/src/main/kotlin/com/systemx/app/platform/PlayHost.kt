package com.systemx.app.platform

import android.app.Activity
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.appupdate.AppUpdateOptions
import com.google.android.play.core.install.InstallStateUpdatedListener
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.InstallStatus
import com.google.android.play.core.install.model.UpdateAvailability
import com.google.android.play.core.review.ReviewManagerFactory

/**
 * In-app review and flexible updates through the Play Store app. Both are
 * no-ops on phones without Play or for builds not installed from Play.
 *
 * A downloaded update is never installed while the app is in use (that
 * restarts it and could interrupt a test): it installs when the app goes to
 * the background, which Play does silently, or at the next launch.
 */
class PlayHost(private val activity: Activity) : PlayApi {
    private val updates by lazy { AppUpdateManagerFactory.create(activity.applicationContext) }

    @Volatile private var downloaded = false
    private var listening = false

    private val installListener = InstallStateUpdatedListener { state ->
        if (state.installStatus() == InstallStatus.DOWNLOADED) downloaded = true
    }

    /** Called when the activity stops: installs a waiting update silently. */
    fun onAppBackground() {
        if (downloaded) Sys.safe { updates.completeUpdate() }
    }

    /** Called when the activity is destroyed. */
    fun dispose() {
        if (listening) Sys.safe { updates.unregisterListener(installListener) }
        listening = false
    }

    override fun requestReview() {
        Sys.safe {
            val manager = ReviewManagerFactory.create(activity.applicationContext)
            manager.requestReviewFlow().addOnCompleteListener { task ->
                if (task.isSuccessful && !activity.isFinishing) {
                    manager.launchReviewFlow(activity, task.result)
                }
            }
        }
    }

    override fun checkForUpdate() {
        Sys.safe {
            updates.appUpdateInfo.addOnSuccessListener { info ->
                if (info.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE &&
                    info.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE) && !activity.isFinishing
                ) {
                    if (!listening) {
                        updates.registerListener(installListener)
                        listening = true
                    }
                    updates.startUpdateFlowForResult(
                        info, activity, AppUpdateOptions.newBuilder(AppUpdateType.FLEXIBLE).build(), UPDATE_REQUEST,
                    )
                } else if (info.installStatus() == InstallStatus.DOWNLOADED) {
                    updates.completeUpdate()
                }
            }
        }
    }

    companion object {
        const val UPDATE_REQUEST = 4109
    }
}
