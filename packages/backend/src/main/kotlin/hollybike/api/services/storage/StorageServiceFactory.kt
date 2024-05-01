package hollybike.api.services.storage

import hollybike.api.Conf

object StorageServiceFactory {
	fun getService(conf: Conf): StorageService {
		val isLocal = conf.storage.localPath != null
		val isFtp = conf.storage.ftpServer != null
		val isS3 = conf.storage.s3BucketName != null

		if (!isFtp && !isLocal && !isS3) {
			throw IllegalArgumentException("No storage configuration provided")
		}

		if (isFtp && isLocal || isFtp && isS3 || isLocal && isS3) {
			throw IllegalArgumentException("Configure only one storage mode")
		}

		return if (isLocal) {
			LocalStorageService(conf.storage.localPath)
		} else if (isFtp) {
			FTPStorageService(
				conf.storage.ftpServer,
				conf.storage.ftpUsername,
				conf.storage.ftpPassword,
				conf.storage.ftpDirectory,
			)
		} else {
			S3StorageService(conf.storage.s3Url, conf.storage.s3BucketName, conf.storage.s3Region)
		}
	}
}