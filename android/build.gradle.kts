allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    if (project.name == "isar_flutter_libs") {
        val manifest = project.projectDir.resolve("src/main/AndroidManifest.xml")
        if (manifest.exists()) {
            val text = manifest.readText()
            val cleaned = text.replace(Regex("""\s+package="[^"]+""""), "")
            if (text != cleaned) {
                manifest.writeText(cleaned)
            }
        }
    }

    afterEvaluate {
        if (project.plugins.hasPlugin("com.android.library")) {
            extensions.configure<com.android.build.gradle.LibraryExtension> {
                namespace = namespace ?: "${project.group ?: "com.example"}.${project.name.replace("-", "")}"
            }
        }
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
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

