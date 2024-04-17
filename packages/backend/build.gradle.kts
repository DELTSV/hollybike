val ktor_version: String by project
val kotlin_version: String by project
val logback_version: String by project

plugins {
	application
	kotlin("jvm") version "1.9.23"
	id("io.ktor.plugin") version "2.3.9"
	id("org.jetbrains.kotlin.plugin.serialization") version "1.9.23"
	id("org.graalvm.buildtools.native") version "0.9.19"
	id("com.google.devtools.ksp") version "1.9.23-1.0.20"
	id("org.liquibase.gradle") version "2.1.1"
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
	implementation("io.ktor:ktor-server-resources:$ktor_version")
	implementation("io.ktor:ktor-server-call-logging:$ktor_version")
	implementation("io.micrometer:micrometer-registry-prometheus:1.6.3")
	implementation("org.ktorm:ktorm-core:3.6.0")
	implementation("com.mchange:c3p0:0.9.5.5")
	implementation("org.ktorm:ktorm-support-postgresql:3.6.0")
	implementation("org.postgresql:postgresql:42.7.3")
	implementation("org.liquibase:liquibase-core:4.25.1")
	ksp(project(":processor"))

	liquibaseRuntime("org.liquibase:liquibase-core:4.24.0")
	liquibaseRuntime("info.picocli:picocli:4.7.5")
	liquibaseRuntime("org.yaml:snakeyaml:2.2")
	liquibaseRuntime("org.postgresql:postgresql:42.7.3")

	testImplementation("io.ktor:ktor-server-tests-jvm")
	testImplementation("org.jetbrains.kotlin:kotlin-test-junit:$kotlin_version")
	testImplementation("io.ktor:ktor-server-test-host-jvm:2.3.9")
}

liquibase {
	activities.register("main") {
		val dbUrl = System.getenv("DB_URL")
		val dbUser = System.getenv("DB_USER")
		val dbPass = System.getenv("DB_PASSWORD")
		val refDbUrl = System.getenv("REF_DB_URL")
		val refDbUser = System.getenv("REF_DB_USER")
		val refDbPass = System.getenv("REF_DB_PASSWORD")
		arguments = mapOf(
			"referenceUrl" to refDbUrl,
			"referenceUsername" to refDbUser,
			"referencePassword" to refDbPass,
			"logLevel" to "info",
			"changelogFile" to "src/main/resources/liquibase-changelog.sql",
			"url" to dbUrl,
			"username" to dbUser,
			"password" to dbPass
		)
	}
	runList = "main"
}

graalvmNative {
	binaries {
		all {
			javaLauncher.set(
				javaToolchains.launcherFor {
					languageVersion.set(JavaLanguageVersion.of(17))
//					vendor.set(JvmVendorSpec.ORACLE)
				},
			)
		}
		named("main") {
			fallback.set(false)
			verbose.set(true)

			buildArgs.add("--initialize-at-build-time")
			buildArgs.add("--initialize-at-run-time=liquibase.util.StringUtil")
			buildArgs.add("--initialize-at-run-time=liquibase.command.core")
			buildArgs.add("--initialize-at-run-time=liquibase.diff.compare.CompareControl")
			buildArgs.add("--initialize-at-run-time=liquibase.snapshot.SnapshotIdService")

			buildArgs.add("--initialize-at-run-time=liquibase.sqlgenerator.core.LockDatabaseChangeLogGenerator")

			buildArgs.add("--install-exit-handlers")
			buildArgs.add("--report-unsupported-elements-at-runtime")

			buildArgs.add("-H:+ReportExceptionStackTraces")
			buildArgs.add("-H:ReflectionConfigurationFiles=${project.projectDir}/build/generated/ksp/main/resources/META-INF/native-image/reflect-config.json",)

			buildArgs.add("-H:JNIConfigurationFiles=${project.projectDir}/src/main/resources/jni-config.json")
			buildArgs.add("-H:ResourceConfigurationFiles=${project.projectDir}/src/main/resources/resource-config.json")

			buildArgs.add("-H:+StaticExecutableWithDynamicLibC")

			resources.autodetect()

			imageName.set(getIN())
		}
	}
}

tasks.register("printVersion") {
	doLast {
		println(project.version)
	}
}
