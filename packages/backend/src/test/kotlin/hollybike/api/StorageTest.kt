package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.services.storage.StorageMode
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
					uploadProfileImageInStorage(it, "user1@hollybike.fr")

					it.get("/storage/u/2/p") {
						header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					}.apply {
						status shouldBe HttpStatusCode.OK
					}
				}
			}
		}



		test("Should return 404 on unknown storage path") {
			onPremiseTestApp {
				uploadProfileImageInStorage(it, "user1@hollybike.fr")

				it.get("/storage/u/20/p") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Inconnu"
				}
			}
		}

		test("Should get storage data in cloud mode") {
			cloudTestApp {
				uploadProfileImageInStorage(it, "user1@hollybike.fr")

				it.get("/storage/u/2/p") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.NotFound
				}
			}
		}
	}
})