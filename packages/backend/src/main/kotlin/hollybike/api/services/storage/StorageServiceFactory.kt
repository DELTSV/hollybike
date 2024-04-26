package hollybike.api.services.storage

import hollybike.api.Conf

object StorageServiceFactory {
	fun getService(conf: Conf, isDevMode: Boolean, isOnPremise: Boolean): StorageService {
		return if (isOnPremise) {
			val isFtp = conf.storage.ftpServer != null
			val isLocal = conf.storage.localPath != null

			if (!isFtp && !isLocal) {
				throw IllegalArgumentException("No storage configuration provided")
			}

			if (isFtp && isLocal) {
				throw IllegalArgumentException("Both FTP and local storage are configured, please choose one")
			}

			if (isLocal) {
				LocalStorageService(conf.storage.localPath)
			} else {
				FTPStorageService(
					conf.storage.ftpServer,
					conf.storage.ftpUsername,
					conf.storage.ftpPassword,
					conf.storage.ftpDirectory,
				)
			}
		} else {
			S3StorageService(isDevMode, conf.storage.s3bucketName, conf.storage.s3region)
		}
	}
}