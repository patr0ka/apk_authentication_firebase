plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val firebaseEnvFile = rootProject.file("../.env")
val generatedGoogleServicesFile = layout.projectDirectory.file("google-services.json")

val generateGoogleServicesConfig by tasks.registering {
    inputs.file(firebaseEnvFile)
    outputs.file(generatedGoogleServicesFile)

    doLast {
        if (!firebaseEnvFile.isFile) {
            throw GradleException("Create the project .env file before building the Android app.")
        }

        val values = firebaseEnvFile.readLines().mapNotNull { line ->
            val entry = line.trim()
            val separator = entry.indexOf('=')
            if (entry.isEmpty() || entry.startsWith("#") || separator <= 0) {
                null
            } else {
                entry.substring(0, separator).trim() to entry.substring(separator + 1).trim()
            }
        }.toMap()

        fun required(name: String): String = values[name]
            ?.takeIf { it.isNotBlank() }
            ?: throw GradleException("Missing $name in the project .env file.")

        fun jsonString(value: String): String =
            "\"${value.replace("\\", "\\\\").replace("\"", "\\\"")}\""

        val projectNumber = required("FIREBASE_MESSAGING_SENDER_ID")
        val projectId = required("FIREBASE_PROJECT_ID")
        val storageBucket = required("FIREBASE_STORAGE_BUCKET")
        val appId = required("FIREBASE_APP_ID")
        val apiKey = required("FIREBASE_API_KEY")

        val json = """
            {
              "project_info": {
                "project_number": ${jsonString(projectNumber)},
                "project_id": ${jsonString(projectId)},
                "storage_bucket": ${jsonString(storageBucket)}
              },
              "client": [
                {
                  "client_info": {
                    "mobilesdk_app_id": ${jsonString(appId)},
                    "android_client_info": {
                      "package_name": "com.example.auth_ta"
                    }
                  },
                  "api_key": [
                    { "current_key": ${jsonString(apiKey)} }
                  ],
                  "services": {
                    "appinvite_service": {
                      "other_platform_oauth_client": []
                    }
                  }
                }
              ],
              "configuration_version": "1"
            }
        """.trimIndent()

        generatedGoogleServicesFile.asFile.writeText(json)
    }
}

tasks.configureEach {
    if (name.endsWith("GoogleServices")) {
        dependsOn(generateGoogleServicesConfig)
    }
}

android {
    namespace = "com.example.auth_ta"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.auth_ta"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
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
