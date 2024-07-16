/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services.storage

import hollybike.api.Conf
import hollybike.api.services.storage.signature.StorageSignatureServiceFactory

object StorageServiceFactory {
	fun getService(conf: Conf, isOnPremise: Boolean): StorageService {
		val signer = StorageSignatureServiceFactory.getService(conf, isOnPremise)

		return if (isOnPremise) {
			val isFtp = conf.storage.ftpServer != null
			val isLocal = conf.storage.localPath != null
			val isS3 = conf.storage.s3BucketName != null && conf.storage.s3Region != null

			val options = listOf(isFtp, isLocal, isS3)

			if (options.filter { it }.size > 1) {
				throw IllegalArgumentException("Too many storage configured, please choose one")
			}

			if (isLocal) {
				LocalStorageService(conf.storage.localPath, signer)
			} else if(isFtp) {
				FTPStorageService(
					conf.storage.ftpServer,
					conf.storage.ftpUsername,
					conf.storage.ftpPassword,
					conf.storage.ftpDirectory,
					signer
				)
			} else if(isS3){
				with(conf.storage) {
					S3StorageService(s3Url, s3BucketName!!, s3Region!!, s3Username, s3Password, signer)
				}
			} else {
				throw IllegalArgumentException("No storage configuration provided")
			}
		} else {
			with(conf.storage) {
				if(s3BucketName == null || s3Region == null) {
					throw IllegalArgumentException("S3 bucket name and region must be provided")
				} else {
					S3StorageService(s3Url, s3BucketName, s3Region, s3Username, s3Password, signer)
				}
			}
		}
	}
}