package hollybike.api

import io.ktor.util.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import java.io.File

val confKey = AttributeKey<Conf>("hollybikeConf")
val Attributes.conf get() = this[confKey]


@Serializable
data class Conf(
	val db: ConfDB,
	val security: ConfSecurity,
	val smtp: ConfSMTP? = null,
	val storage: ConfStorage = ConfStorage()
)

@Serializable
data class ConfDB(
	val url: String,
	val username: String,
	val password: String
)

@Serializable
data class ConfSecurity(
	val audience: String,
	val domain: String,
	val realm: String,
	val secret: String
)

@Serializable
data class ConfSMTP(
	val url: String,
	val port: Int,
	val sender: String,
	val username: String? = null,
	val password: String? = null
)

@Serializable
data class ConfStorage(
	val s3Url: String? = null,
	val s3BucketName: String? = null,
	val s3Region: String? = null,
	val s3Username: String? = null,
	val s3Password: String? = null,
	val localPath: String? = null,
	val ftpServer: String? = null,
	val ftpUsername: String? = null,
	val ftpPassword: String? = null,
	val ftpDirectory: String? = null
)

fun parseConf(): Conf {
	val f = File("./app.json")
	return if (f.exists()) {
		parseFileConf(f)
	} else {
		parseEnvConf()
	}
}

private val json = Json {
	ignoreUnknownKeys = true
}

private fun parseFileConf(f: File): Conf = json.decodeFromString(f.readText())

private fun parseEnvConf() = Conf(
	ConfDB(
		System.getenv("DB_URL"),
		System.getenv("DB_USERNAME"),
		System.getenv("DB_PASSWORD")
	),
	ConfSecurity(
		System.getenv("SECURITY_AUDIENCE"),
		System.getenv("SECURITY_DOMAIN"),
		System.getenv("SECURITY_REALM"),
		System.getenv("SECURITY_SECRET")
	),
	parseEnvSMTPConv(),
	ConfStorage(
		System.getenv("STORAGE_S3_URL"),
		System.getenv("STORAGE_S3_BUCKET_NAME"),
		System.getenv("STORAGE_S3_REGION"),
		System.getenv("STORAGE_LOCAL_PATH"),
		System.getenv("STORAGE_FTP_SERVER"),
		System.getenv("STORAGE_FTP_USERNAME"),
		System.getenv("STORAGE_FTP_PASSWORD"),
		System.getenv("STORAGE_FTP_DIRECTORY")
	)
)

private fun parseEnvSMTPConv(): ConfSMTP? {
	try {
		val conf = ConfSMTP(
			System.getenv("SMTP_URL"),
			System.getenv("SMTP_PORT").toInt(),
			System.getenv("SMTP_USERNAME"),
			System.getenv("SMTP_PASSWORD"),
			System.getenv("SMTP_SENDER"),
		)
		return conf
	} catch (_: NullPointerException) {
		return null
	}
}