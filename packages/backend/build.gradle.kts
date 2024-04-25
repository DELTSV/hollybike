val ktorVersion: String by project
val kotlinVersion: String by project
val logbackVersion: String by project
val exposedVersion: String by project
val awsSdkKotlinVersion: String by project

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
}

repositories {
	mavenCentral()
}

dependencies {
	implementation("io.ktor:ktor-server-core:$ktorVersion")
	implementation("io.ktor:ktor-server-cio:$ktorVersion")
	implementation("io.ktor:ktor-server-content-negotiation:$ktorVersion")
	implementation("io.ktor:ktor-serialization-kotlinx-json:$ktorVersion")
	implementation("ch.qos.logback:logback-classic:$logbackVersion")
	implementation("io.ktor:ktor-server-websockets:$ktorVersion")
	implementation("io.ktor:ktor-server-caching-headers:$ktorVersion")
	implementation("io.ktor:ktor-server-cors:$ktorVersion")
	implementation("io.ktor:ktor-server-auth:$ktorVersion")
	implementation("io.ktor:ktor-server-auth-jwt:$ktorVersion")
	implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.6.0-RC.2")
	implementation("io.ktor:ktor-server-metrics-micrometer-jvm:$ktorVersion")
	implementation("io.ktor:ktor-server-swagger-jvm:$ktorVersion")
	implementation("io.ktor:ktor-server-compression-jvm:$ktorVersion")
	implementation("io.ktor:ktor-server-resources:$ktorVersion")
	implementation("io.ktor:ktor-server-call-logging:$ktorVersion")
	implementation("de.nycode:bcrypt:2.2.0")
	implementation("io.micrometer:micrometer-registry-prometheus:1.6.3")
	implementation("org.jetbrains.exposed:exposed-core:$exposedVersion")
	implementation("org.jetbrains.exposed:exposed-jdbc:$exposedVersion")
	implementation("org.jetbrains.exposed:exposed-dao:$exposedVersion")
	implementation("org.jetbrains.exposed:exposed-kotlin-datetime:$exposedVersion")

	implementation("aws.sdk.kotlin:s3:$awsSdkKotlinVersion")

	implementation("com.squareup.okhttp3:okhttp:5.0.0-alpha.14")

	implementation("org.postgresql:postgresql:42.7.3")
	implementation("org.liquibase:liquibase-core:4.27.0")
	ksp(project(":processor"))

	liquibaseRuntime("org.liquibase:liquibase-core:4.27.0")
	liquibaseRuntime("info.picocli:picocli:4.7.5")
	liquibaseRuntime("org.yaml:snakeyaml:2.2")
	liquibaseRuntime("org.postgresql:postgresql:42.7.3")

	testImplementation("io.ktor:ktor-server-tests-jvm")
	testImplementation("org.jetbrains.kotlin:kotlin-test-junit:$kotlinVersion")
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
		arguments =
			mapOf(
				"referenceUrl" to refDbUrl,
				"referenceUsername" to refDbUser,
				"referencePassword" to refDbPass,
				"logLevel" to "info",
				"changelogFile" to "src/main/resources/liquibase-changelog.sql",
				"url" to dbUrl,
				"username" to dbUser,
				"password" to dbPass,
			)
	}
	runList = "main"
}

graalvmNative {
	agent {
		defaultMode.set("standard")
	}

	binaries {
		all {
			javaLauncher.set(
				javaToolchains.launcherFor {
					languageVersion.set(JavaLanguageVersion.of(21))
// 					vendor.set(JvmVendorSpec.ORACLE)
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

			buildArgs.add("--initialize-at-run-time=de.nycode.bcrypt.BCryptKt")

// 			buildArgs.add("--initialize-at-run-time=java.time.zone.ZoneRulesProvider")
// 			buildArgs.add("--initialize-at-run-time=java.time.ZoneRegion")
//
// 			buildArgs.add("--trace-class-initialization=java.time.zone.ZoneRulesProvider")

			buildArgs.add("--install-exit-handlers")
			buildArgs.add("--report-unsupported-elements-at-runtime")

			buildArgs.add("-H:+ReportExceptionStackTraces")
			buildArgs.add(
				"-H:ReflectionConfigurationFiles=${project.projectDir}/build/generated/ksp/main/resources/META-INF/native-image/reflect-config.json",
			)

			buildArgs.add("-H:JNIConfigurationFiles=${project.projectDir}/src/main/resources/jni-config.json")
			buildArgs.add("-H:ResourceConfigurationFiles=${project.projectDir}/src/main/resources/resource-config.json")
			buildArgs.add("-H:DynamicProxyConfigurationFiles=${project.projectDir}/src/main/resources/proxy-config.json")

			buildArgs.add("-H:+StaticExecutableWithDynamicLibC")

			buildArgs.add("--features=okhttp3.internal.graal.OkHttpFeature")

			resources.autodetect()

			imageName.set(getIN())
		}
	}

	metadataRepository {
		enabled.set(true)
	}
}

tasks.register("printVersion") {
	doLast {
		println(project.version)
	}
}
