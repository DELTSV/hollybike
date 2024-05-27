package hollybike.api.services.storage.signature

sealed interface StorageSignatureService {
	val mode: StorageSignatureMode
	val sign: (String) -> String
}