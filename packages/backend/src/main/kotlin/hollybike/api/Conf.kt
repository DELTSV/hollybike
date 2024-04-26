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
	val storage: ConfStorage = ConfStorage(),
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
data class ConfStorage(
	var S3bucketName: String? = null,
	val S3region: String = "eu-west-3",
	val localPath: String? = null
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
	ConfStorage(
		System.getenv("STORAGE_S3_BUCKET_NAME"),
		System.getenv("STORAGE_S3_REGION"),
		System.getenv("STORAGE_LOCAL_PATH")
	)
)