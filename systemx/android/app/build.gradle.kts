import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing. android/key.properties is created on your machine only and
// is git-ignored; without it, release builds fall back to the debug key so
// they still install for testing (Play Console will reject those).
val keyProps = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}
val hasReleaseKey = keyProps.getProperty("storeFile") != null

android {
    namespace = "com.systemx.app"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Permanent once the first build is uploaded to Play Console.
        applicationId = "com.systemx.app"
        minSdk = 26
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                storeFile = file(keyProps.getProperty("storeFile"))
                storePassword = keyProps.getProperty("storePassword")
                keyAlias = keyProps.getProperty("keyAlias")
                keyPassword = keyProps.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKey) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    // History sampling, charger watch and summaries while the app is closed.
    implementation("androidx.work:work-runtime-ktx:2.10.1")
    // In-app review and updates through the Play Store app (no network
    // access of our own).
    implementation("com.google.android.play:review:2.0.2")
    implementation("com.google.android.play:app-update:2.1.0")
    // Plain JVM tests for the system file parsers: ./gradlew :app:testDebugUnitTest
    testImplementation("junit:junit:4.13.2")
}

// An app bundle is what goes to Play, and Play rejects debug-signed uploads:
// fail early instead of quietly signing with the debug key. APKs for local
// testing may still use the debug key.
// Only the requested task counts: an APK build also runs internal tasks
// such as bundleReleaseResources.
gradle.taskGraph.whenReady {
    val bundlingRelease = gradle.startParameter.taskNames.any {
        it.substringAfterLast(':') == "bundleRelease"
    }
    if (bundlingRelease && !hasReleaseKey) {
        throw GradleException("Release bundles need android/key.properties with the upload key (see release/README.md).")
    }
}
