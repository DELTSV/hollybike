plugins {
	id("org.gradle.toolchains.foojay-resolver-convention") version "0.5.0"
}
rootProject.name = "hollybike.api"
val ktor_version = "2.3.9"
include("processor")
