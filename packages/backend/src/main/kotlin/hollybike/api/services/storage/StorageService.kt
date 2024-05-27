package hollybike.api.services.storage

sealed interface StorageService {
	val mode: StorageMode
	val signer: (String) -> String

	suspend fun store(data: ByteArray, path: String, dataContentType: String)
	suspend fun retrieve(path: String): ByteArray?
}