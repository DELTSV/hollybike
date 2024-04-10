plugins {
    kotlin("jvm")
}

group = "hollybike.api"
version = "unspecified"

repositories {
    mavenCentral()
}

dependencies {
    implementation("com.google.devtools.ksp:symbol-processing-api:1.9.21-1.0.15")
}

tasks.test {
    useJUnitPlatform()
}
kotlin {
    jvmToolchain(21)
}