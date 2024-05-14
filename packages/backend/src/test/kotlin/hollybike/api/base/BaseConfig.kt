package hollybike.api.base

import hollybike.api.services.storage.StorageMode

data class BaseConfig(
	val storageMode: StorageMode = StorageMode.S3,
	val isOnPremise: Boolean = false,
)