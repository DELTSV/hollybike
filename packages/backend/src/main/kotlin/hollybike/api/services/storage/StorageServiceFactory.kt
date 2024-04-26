package hollybike.api.services.storage

import hollybike.api.Conf

object StorageServiceFactory {
	fun getService(conf: Conf, isDevMode: Boolean, isOnPremise: Boolean): StorageService {
		return if (isOnPremise) {
			if (isDevMode) {
				LocalStorageService()
			} else {
				FTPStorageService()
			}
		} else {
			S3StorageService(isDevMode, conf.storage.bucketName, conf.storage.region)
		}
	}
}