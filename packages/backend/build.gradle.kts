val ktor_version: String by project
val kotlin_version: String by project
val logback_version: String by project

plugins {
	application
	kotlin("jvm") version "1.9.23"
	id("io.ktor.plugin") version "2.3.9"
	id("org.jetbrains.kotlin.plugin.serialization") version "1.9.23"
	id("org.graalvm.buildtools.native") version "0.9.19"
}

group = "hollybike.api"

fun getIN(): String {
	if (hasProperty("image_name")) {
		return project.findProperty("image_name") as String
	}

	return "hollybike_server"
}

application {
	mainClass.set("hollybike.api.ApplicationKt")

	val isDevelopment: Boolean = project.ext.has("development")
	applicationDefaultJvmArgs = listOf("-Dio.ktor.development=$isDevelopment")
}

repositories {
	mavenCentral()
}
dependencies {
	implementation("io.ktor:ktor-server-core:$ktor_version")
	implementation("io.ktor:ktor-server-cio:$ktor_version")
	implementation("io.ktor:ktor-server-content-negotiation:$ktor_version")
	implementation("io.ktor:ktor-serialization-kotlinx-json:$ktor_version")
	implementation("ch.qos.logback:logback-classic:$logback_version")
	implementation("io.ktor:ktor-server-websockets:$ktor_version")
	implementation("io.ktor:ktor-server-caching-headers:$ktor_version")
	implementation("io.ktor:ktor-server-cors:$ktor_version")
	implementation("io.ktor:ktor-server-auth:$ktor_version")
	implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.6.0-RC.2")
	implementation("io.ktor:ktor-server-metrics-micrometer-jvm:$ktor_version")
	implementation("io.ktor:ktor-server-swagger-jvm:$ktor_version")
	implementation("io.ktor:ktor-server-compression-jvm:$ktor_version")
	implementation("io.ktor:ktor-server-auth-jwt:$ktor_version")
	implementation("io.micrometer:micrometer-registry-prometheus:1.6.3")
	testImplementation("io.ktor:ktor-server-tests-jvm")
	testImplementation("org.jetbrains.kotlin:kotlin-test-junit:$kotlin_version")
	testImplementation("io.ktor:ktor-server-test-host-jvm:2.3.9")
}

graalvmNative {
	binaries {
		all {
			javaLauncher.set(
				javaToolchains.launcherFor {
					languageVersion.set(JavaLanguageVersion.of(21))
					vendor.set(JvmVendorSpec.ORACLE)
				},
			)
		}
		named("main") {
			fallback.set(false)
			verbose.set(true)

			buildArgs.add("--initialize-at-build-time")

			buildArgs.add("-H:+InstallExitHandlers")
			buildArgs.add("-H:+ReportUnsupportedElementsAtRuntime")
			buildArgs.add("-H:+ReportExceptionStackTraces")
			buildArgs.add(
				"-H:ReflectionConfigurationFiles=${project.projectDir}/src/main/resources/META-INF/native-image/reflect-config.json",
			)

			imageName.set(getIN())
		}
	}
}

tasks.register("printVersion") {
	doLast {
		println(project.version)
	}
}
