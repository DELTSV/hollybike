package hollybike.api.services.storage

import hollybike.api.Conf

object StorageServiceFactory {
	fun getService(conf: Conf, isDevMode: Boolean, isOnPremise: Boolean): StorageService {
		return if (isOnPremise) {
			val isFtp = conf.storage.ftpServer != null
			val isLocal = conf.storage.localPath != null
			val isS3 = conf.storage.s3Url != null

			val options = listOf(isFtp, isLocal, isS3)

			if (options.filter { it }.size > 1) {
				throw IllegalArgumentException("Too many storage configured, please choose one")
			}

			if (isLocal) {
				LocalStorageService(conf.storage.localPath)
			} else if(isFtp) {
				FTPStorageService(
					conf.storage.ftpServer,
					conf.storage.ftpUsername,
					conf.storage.ftpPassword,
					conf.storage.ftpDirectory,
				)
			} else if(isS3){
				with(conf.storage) {
					if(s3Url == null || s3BucketName == null || s3Region == null) {
						throw IllegalArgumentException("When S3 enabled, S3 url, bucket name and region must be provided")
					} else {
						S3StorageService(s3Url, s3BucketName, s3Region, isDevMode, s3Username, s3Password)
					}
				}
			} else {
				throw IllegalArgumentException("No storage configuration provided")
			}
		} else {
			with(conf.storage) {
				if(s3Url == null || s3BucketName == null || s3Region == null) {
					throw IllegalArgumentException("S3 url, bucket name and region must be provided")
				} else {
					S3StorageService(s3Url, s3BucketName, s3Region, isDevMode, s3Username, s3Password)
				}
			}
		}
	}
}