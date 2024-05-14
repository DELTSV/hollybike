package hollybike.api.services.storage

import org.apache.commons.net.PrintCommandListener
import org.apache.commons.net.ftp.FTP
import org.apache.commons.net.ftp.FTPClient
import java.io.ByteArrayInputStream
import kotlin.concurrent.fixedRateTimer

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

		ftpClient.addProtocolCommandListener(
			PrintCommandListener(System.out, true)
		)

		val server = ftpServer.removePrefix("ftp://")
		val serverParts = server.split(":")
		val serverHost = serverParts[0]
		val serverPort = serverParts.getOrNull(1)?.toIntOrNull() ?: 21

		if (serverPort !in 1..65535) {
			throw IllegalArgumentException("Invalid FTP port")
		}

		ftpClient.connect(serverHost, serverPort)

		if (!ftpClient.login(ftpUsername, ftpPassword)) {
			throw Exception("Cannot login to FTP server, verify your credentials")
		}

		ftpClient.enterLocalPassiveMode()
		ftpClient.setFileType(FTP.BINARY_FILE_TYPE)

		if (!ftpClient.changeWorkingDirectory(ftpDirectory)) {
			if (ftpClient.createDirectoryTree(ftpDirectory)) {
				ftpClient.changeWorkingDirectory(ftpDirectory)
			} else {
				throw Exception("Cannot create base directory tree $ftpDirectory")
			}
		}

		fixedRateTimer("FTP keep alive", true, 0, 1000 * 60 * 5) {
			ftpClient.sendNoOp()
		}
	}

	private fun FTPClient.createDirectoryTree(directory: String): Boolean {
		val directories = directory.split("/")

		fun directoryExists(directoryPath: String, dir: String): Boolean {
			val files = listDirectories(directoryPath)
			return files.any { it.name == dir }
		}

		var currentPath = ""
		for (dir in directories) {
			if (!directoryExists(currentPath, dir)) {
				val dirPath = currentPath + dir

				if (!makeDirectory(dirPath)) {
					return false
				}
			}

			currentPath += "$dir/"
		}

		return true
	}

	override suspend fun store(data: ByteArray, path: String, dataContentType: String) {
		val pathWithoutFile = path.substringBeforeLast("/")
		if (!ftpClient.createDirectoryTree(pathWithoutFile)) {
			throw Exception("Cannot create directory tree")
		}

		if (!ftpClient.storeFile(path, ByteArrayInputStream(data))) {
			throw Exception("Cannot store file, check your permissions")
		}
	}

	override suspend fun retrieve(path: String): ByteArray? {
		val outputStream = ftpClient.retrieveFileStream(path) ?: return null
		val bytes = outputStream.readBytes()

		ftpClient.completePendingCommand()
		return bytes
	}
}