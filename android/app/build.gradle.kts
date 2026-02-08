plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// Prefer environment variables for CI; fall back to key.properties; then defaults
val envStoreFile = System.getenv("KEYSTORE_PATH")
val envStorePassword = System.getenv("KEYSTORE_PASSWORD")
val envKeyAlias = System.getenv("KEY_ALIAS") ?: System.getenv("KEY_ALIAS_NAME")
val envKeyPassword = System.getenv("KEY_PASSWORD")

fun propOrEnv(propName: String, envValue: String?, default: String): String {
    return envValue ?: keystoreProperties.getProperty(propName, default)
}


android {
    namespace = "com.berlin.bible_reader"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.berlin.bible_reader"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val storeFilePath = propOrEnv("storeFile", envStoreFile, "upload-keystore.jks")
            storeFile = file(storeFilePath)
            storePassword = propOrEnv("storePassword", envStorePassword, "123456")
            keyAlias = propOrEnv("keyAlias", envKeyAlias, "bible")
            keyPassword = propOrEnv("keyPassword", envKeyPassword, "123456")
        }
        getByName("debug") { // Configure the existing debug signing config
            val storeFilePath = propOrEnv("storeFile", envStoreFile, "upload-keystore.jks")
            storeFile = file(storeFilePath)
            storePassword = propOrEnv("storePassword", envStorePassword, "123456")
            keyAlias = propOrEnv("keyAlias", envKeyAlias, "bible")
            keyPassword = propOrEnv("keyPassword", envKeyPassword, "123456")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
