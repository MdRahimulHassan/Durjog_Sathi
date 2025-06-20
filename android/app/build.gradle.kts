// App-level build.gradle.kts

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // version declared only in top-level
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.durjog_sathi"
    compileSdk = 34  // or use flutter.compileSdkVersion if you have that variable

    ndkVersion = "27.0.12077973" // Optional for Firebase native libs

    defaultConfig {
        applicationId = "com.example.durjog_sathi"
        minSdk = 23  // Firebase Auth 23.x+ requires minSdk 23
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            // Use debug signing for now; change for actual release
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BOM manages versions for Firebase libraries
    implementation(platform("com.google.firebase:firebase-bom:33.15.0"))

    // Firebase libraries - no version needed due to BOM
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")

    // Add any other Firebase dependencies you require
}
