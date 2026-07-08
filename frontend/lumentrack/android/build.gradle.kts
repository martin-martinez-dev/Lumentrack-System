// build.gradle.kts (Raíz)

buildscript {
    repositories {
        google()       // Necesario para encontrar com.google.gms:google-services
        mavenCentral() // Recomendado
    }
    dependencies {
        // La versión 4.4.1 está bien
        classpath("com.google.gms:google-services:4.4.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Configuración de rutas de compilación (mantenla así si te funciona bien)
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    project.layout.buildDirectory.value(newBuildDir.dir(project.name))
}

// Nota: evaluationDependsOn puede ralentizar la compilación. 
// Úsalo solo si tienes una dependencia circular estricta.
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}