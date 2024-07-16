/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services.storage.signature

import hollybike.api.Conf

object StorageSignatureServiceFactory {
	fun getService(conf: Conf, isOnPremise: Boolean): StorageSignatureService {
		val isCloudFront = conf.security.cfPrivateKeySecret != null && conf.security.cfKeyPairId != null

		if (isOnPremise || !isCloudFront) {
			return JWTStorageSignatureService(conf.security)
		}

		return CloudFrontStorageSignatureService(conf.security)
	}
}