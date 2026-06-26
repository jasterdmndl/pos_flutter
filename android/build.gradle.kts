allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// =========================================================================
// FIX FOR ISAR & MODERN ANDROID SDK (SDK 36)
// =========================================================================
subprojects {
    afterEvaluate {
        val project = this
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            
            // 1. Force Namespace for Isar (Required for AGP 8+)
            if (android.namespace == null && project.name == "isar_flutter_libs") {
                android.namespace = "dev.isar.isar_flutter_libs"
            }
            
            // 2. Force Compile SDK to 36 to satisfy latest androidx dependencies
            // Modern Flutter packages are starting to require the newest Android 16 (API 36)
            android.compileSdkVersion(36)
        }
    }
}
// =========================================================================

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
