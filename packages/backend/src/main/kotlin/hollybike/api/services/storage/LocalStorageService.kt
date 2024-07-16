/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services.storage

import hollybike.api.services.storage.signature.StorageSignatureService
import java.io.File

class LocalStorageService(
	private val storagePath: String?,
	override val signer: StorageSignatureService
) : StorageService {
	override val mode = StorageMode.LOCAL

	init {
		if (storagePath == null) {
			throw IllegalArgumentException("Storage path is not set")
		}

		val directory = File(storagePath)

		if (!directory.exists()) {
			directory.mkdirs()
		}

		if (!directory.isDirectory) {
			throw IllegalArgumentException("Storage path is not a directory")
		}

		if (!directory.canRead() || !directory.canWrite()) {
			throw IllegalArgumentException("Storage path is not readable or writable")
		}
	}

	override suspend fun store(data: ByteArray, path: String, dataContentType: String) {
		val file = File("$storagePath/$path")

		file.parentFile.mkdirs()
		file.writeBytes(data)
	}

	override suspend fun retrieve(path: String): ByteArray? {
		val file = File("$storagePath/$path")

		if (!file.exists()) {
			return null
		}

		return file.readBytes()
	}

	override suspend fun delete(path: String) {
		val file = File("$storagePath/$path")

		if (file.exists()) {
			file.delete()
		}
	}

	override suspend fun batchStore(data: List<Pair<ByteArray, String>>, dataContentType: String) {
		data.forEach { (data, path) ->
			store(data, path, dataContentType)
		}
	}

	override suspend fun batchDelete(paths: List<String>) {
		paths.forEach { path ->
			delete(path)
		}
	}
}