/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services.storage.signature

sealed interface StorageSignatureService {
	val mode: StorageSignatureMode
	val sign: (String) -> String
}