package hollybike.api.services.storage

interface StorageService {
	val mode: StorageMode

	suspend fun store(data: ByteArray, path: String, dataContentType: String)
	suspend fun retrieve(path: String): ByteArray?
}