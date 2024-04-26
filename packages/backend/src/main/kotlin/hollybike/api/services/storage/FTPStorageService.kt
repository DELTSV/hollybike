package hollybike.api.services.storage

class FTPStorageService: StorageService {
	override suspend fun store(data: ByteArray, path: String, dataContentType: String) {
		// TODO: Store the file in FTP
	}

	override suspend fun retrieve(path: String): ByteArray? {
		// TODO: Retrieve the file from FTP

		println("Retrieving $path")

		return null
	}
}