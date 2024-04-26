package hollybike.api.services.storage

import org.apache.commons.net.ftp.FTP
import org.apache.commons.net.ftp.FTPClient
import java.io.ByteArrayInputStream

class FTPStorageService(
	ftpServer: String?,
	ftpUsername: String?,
	ftpPassword: String?,
	ftpDirectory: String?,
) : StorageService {
	override val mode = StorageMode.FTP

	private val ftpClient = FTPClient()

	init {
		if (ftpServer == null || ftpUsername == null || ftpPassword == null || ftpDirectory == null) {
			throw IllegalArgumentException("FTP configuration is missing")
		}

		ftpClient.connect(ftpServer)
		ftpClient.login(ftpUsername, ftpPassword)
		ftpClient.enterLocalPassiveMode()
		ftpClient.setFileType(FTP.BINARY_FILE_TYPE)
		ftpClient.changeWorkingDirectory(ftpDirectory)
	}

	override suspend fun store(data: ByteArray, path: String, dataContentType: String) {
		ftpClient.storeFile(path, ByteArrayInputStream(data))
	}

	override suspend fun retrieve(path: String): ByteArray? {
		// TODO: Retrieve the file from FTP

		println("Retrieving $path")

		return null
	}
}