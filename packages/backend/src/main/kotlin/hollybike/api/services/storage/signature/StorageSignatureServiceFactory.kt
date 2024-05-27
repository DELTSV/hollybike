package hollybike.api.services.storage.signature

import hollybike.api.Conf

object StorageSignatureServiceFactory {
	fun getService(conf: Conf, isOnPremise: Boolean): StorageSignatureService {
		if (isOnPremise) {
			return LocalStorageSignatureService(conf.security)
		}

		return CloudStorageSignatureService(conf.security)
	}
}