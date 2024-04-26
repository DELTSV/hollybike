package hollybike.api.services.storage
import java.io.File

class LocalStorageService: StorageService {
	override suspend fun store(data: ByteArray, path: String, contentType: String) {
		// Store the file in S3
	}

	override fun retrieve(id: String): File {
		// Retrieve the file from S3

		return File("file")
	}
}