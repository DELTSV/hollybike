package hollybike.api.services.storage

import hollybike.api.services.storage.signature.StorageSignatureService

sealed interface StorageService {
	val mode: StorageMode
	val signer: StorageSignatureService

	suspend fun store(data: ByteArray, path: String, dataContentType: String)
	suspend fun retrieve(path: String): ByteArray?
	suspend fun delete(path: String)
	suspend fun batchStore(data: List<Pair<ByteArray, String>>, dataContentType: String)
	suspend fun batchDelete(paths: List<String>)
}