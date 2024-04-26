package hollybike.api.services.storage

import java.io.File

interface StorageService {
	suspend fun store(data: ByteArray, path: String, contentType: String)
	fun retrieve(id: String): File
}