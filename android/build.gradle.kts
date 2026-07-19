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

    // Configure compile SDK and namespace overrides before subprojects are evaluated
    afterEvaluate {
        val android = extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        if (android != null) {
            // Force transitive dependency compatibility
            android.compileSdkVersion(34)

            // Inject namespace for dependencies that lack it
            if (android.namespace == null) {
                android.namespace = "dev.isar.${project.name.replace("-", "_").replace(".", "_")}"
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
