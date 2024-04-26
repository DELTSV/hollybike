package hollybike.api.services.storage

import java.io.File

class LocalStorageService(
	private val storagePath: String?,
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
}