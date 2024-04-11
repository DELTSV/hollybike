package hollybike.api

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import java.io.File

@Serializable
data class Conf(
	val db: ConfDB
)

@Serializable
data class ConfDB(
	val url: String,
	val username: String,
	val password: String
)

fun parseConf(): Conf {
	val f = File("./app.json")
	return if(f.exists()) {
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
	)
)