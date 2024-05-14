package hollybike.api.base

import hollybike.api.services.storage.StorageMode

data class BaseConfig(
	val storageMode: StorageMode,
	val isOnPremise: Boolean = true,
)