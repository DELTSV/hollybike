package hollybike.api.services.storage.signature

sealed interface StorageSignatureService {
	val signer: (String) -> String
}