package hollybike.api.services.storage

import hollybike.api.Conf

object StorageServiceFactory {
	fun getService(conf: Conf, isDevMode: Boolean, isOnPremise: Boolean): StorageService {
		return if (isOnPremise) {
			if (isDevMode) {
				LocalStorageService(conf.storage.localPath)
			} else {
				FTPStorageService()
			}
		} else {
			S3StorageService(isDevMode, conf.storage.S3bucketName, conf.storage.S3region)
		}
	}
}