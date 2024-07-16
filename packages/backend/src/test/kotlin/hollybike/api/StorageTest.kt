/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.base.auth
import hollybike.api.services.storage.StorageMode
import hollybike.api.stores.UserStore
import io.kotest.matchers.shouldBe
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*

class StorageTest : IntegrationSpec({
	context("Get root welcome message") {
		test("Should send welcome message for storage") {
			onPremiseTestApp {
				it.get("/storage").apply {
					status shouldBe HttpStatusCode.OK
					bodyAsText() shouldBe "Bienvenue le storage de hollybike"
				}
			}
		}

		test("Should not send welcome message for storage in cloud mode") {
			cloudTestApp {
				it.get("/storage").apply {
					status shouldBe HttpStatusCode.NotFound
				}
			}
		}
	}

	context("Get storage data") {
		listOf(
			StorageMode.S3,
			StorageMode.LOCAL,
			StorageMode.FTP
		).forEach { storageMode ->
			test("Should get storage data in $storageMode mode") {
				onPremiseTestApp(storageMode) {
					val path = uploadProfileImageInStorage(it, UserStore.user1).removePrefix("domain")

					it.get(path) {
						auth(UserStore.user1)
					}.apply {
						status shouldBe HttpStatusCode.OK
					}
				}
			}
		}



		test("Should return 401 on unknown storage signature") {
			onPremiseTestApp {
				uploadProfileImageInStorage(it, UserStore.user1)

				it.get("/storage/object?signature=unknown-signature") {
					auth(UserStore.user1)
				}.apply {
					status shouldBe HttpStatusCode.Unauthorized
				}
			}
		}

		test("Should not get storage data in cloud mode") {
			cloudTestApp {
				val path = uploadProfileImageInStorage(it, UserStore.user1).removePrefix("domain")

				it.get(path) {
					auth(UserStore.user1)
				}.apply {
					status shouldBe HttpStatusCode.NotFound
				}
			}
		}
	}
})