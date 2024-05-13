package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.types.association.TAssociation
import hollybike.api.types.association.TNewAssociation
import hollybike.api.types.association.TUpdateAssociation
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserScope
import io.kotest.matchers.equality.shouldBeEqualToIgnoringFields
import io.kotest.matchers.shouldBe
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.request.forms.*
import io.ktor.client.statement.*
import io.ktor.http.*
import java.io.File

class AssociationTest : IntegrationSpec({
	test("Should return the my association") {
		testApp {
			it.get("/api/associations/me") {
				header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
			}.apply {
				status shouldBe HttpStatusCode.OK
				body<TAssociation>().shouldBeEqualToIgnoringFields(
					TAssociation(
						id = 1,
						name = "Test Association 1",
						status = EAssociationsStatus.Enabled,
						picture = null
					),
					TAssociation::id
				)
			}
		}
	}

	test("Should not return my association if not admin") {
		testApp {
			it.get("/api/associations/me") {
				header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
			}.apply {
				status shouldBe HttpStatusCode.Forbidden
				bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
			}
		}
	}

	///////////////////////////

	test("Should update my association") {
		testApp {
			it.patch("/api/associations/me") {
				header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				contentType(ContentType.Application.Json)
				setBody(TUpdateAssociation(
					name = "Updated Association",
					status = EAssociationsStatus.Disabled
				))
			}.apply {
				status shouldBe HttpStatusCode.OK

				body<TAssociation>().shouldBeEqualToIgnoringFields(
					TAssociation(
						id = 2,
						name = "Updated Association",
						status = EAssociationsStatus.Enabled,
						picture = null
					),
					TAssociation::id
				)
			}
		}
	}

	test("Should not update my association if not admin") {
		testApp {
			it.patch("/api/associations/me") {
				header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
				contentType(ContentType.Application.Json)
				setBody(TUpdateAssociation(
					name = "Updated Association",
					status = EAssociationsStatus.Disabled
				))
			}.apply {
				status shouldBe HttpStatusCode.Forbidden

				bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
			}
		}
	}

	test("Should not update my association if the name already exists") {
		testApp {
			it.patch("/api/associations/me") {
				header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				contentType(ContentType.Application.Json)
				setBody(TUpdateAssociation(
					name = "Test Association 2",
				))
			}.apply {
				status shouldBe HttpStatusCode.Conflict
				bodyAsText() shouldBe "L'association existe déjà"
			}
		}
	}

	///////////////////////////

	listOf(
		"image/jpeg",
		"image/png"
	).forEach { contentType ->
		test("Should upload my association $contentType picture") {
			testApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/associations/me/picture") {
					val boundary = "WebAppBoundary"
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
					setBody(
						MultiPartFormDataContent(
							formData {
								append("file", file.readBytes(), Headers.build {
									append(HttpHeaders.ContentType, contentType)
									append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
								})
							},
							boundary,
							ContentType.MultiPart.FormData.withParameter("boundary", boundary)
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}
	}

	test("Should not upload my association picture if not admin") {
		testApp {
			val file = File(
				javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
			)

			it.patch("/api/associations/me/picture") {
				val boundary = "WebAppBoundary"
				header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
				setBody(
					MultiPartFormDataContent(
						formData {
							append("file", file.readBytes(), Headers.build {
								append(HttpHeaders.ContentType, "image/jpeg")
								append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
							})
						},
						boundary,
						ContentType.MultiPart.FormData.withParameter("boundary", boundary)
					)
				)
			}.apply {
				status shouldBe HttpStatusCode.Forbidden
				bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
			}
		}
	}

	listOf(
		"image/gif",
		"image/svg+xml",
		"image/webp",
		"application/javascript",
	).forEach { contentType ->
		test("Should not upload my association $contentType picture") {
			testApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/associations/me/picture") {
					val boundary = "WebAppBoundary"
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
					setBody(
						MultiPartFormDataContent(
							formData {
								append("file", file.readBytes(), Headers.build {
									append(HttpHeaders.ContentType, contentType)
									append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
								})
							},
							boundary,
							ContentType.MultiPart.FormData.withParameter("boundary", boundary)
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest
					bodyAsText() shouldBe "Image invalide (JPEG et PNG seulement)"
				}
			}
		}
	}

	test("Should not upload my association picture with no content type") {
		testApp {
			val file = File(
				javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
			)

			it.patch("/api/associations/me/picture") {
				val boundary = "WebAppBoundary"
				header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				setBody(
					MultiPartFormDataContent(
						formData {
							append("file", file.readBytes(), Headers.build {
								append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
							})
						},
						boundary,
						ContentType.MultiPart.FormData.withParameter("boundary", boundary)
					)
				)
			}.apply {
				status shouldBe HttpStatusCode.BadRequest
				bodyAsText() shouldBe "Type de contenu de l'image manquant"
			}
		}
	}

	///////////////////////////

	test("Should get all associations") {
		testApp {
			it.get("/api/associations") {
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
			}.apply {
				status shouldBe HttpStatusCode.OK

				val body = body<TLists<TAssociation>>()

				body.shouldBeEqualToIgnoringFields(
					TLists(
						data = listOf(),
						page = 0,
						totalPage = 1,
						perPage = 20,
						totalData = 4
					),
					TLists<TAssociation>::data
				)

				body.data.size shouldBe 4
			}
		}
	}

	mapOf(
		"admin1@hollybike.fr" to EUserScope.Admin,
		"user1@hollybike.fr" to EUserScope.User,
	).forEach { (email, scope) ->
		test("Should not get all associations if $scope") {
			testApp {
				it.get("/api/associations") {
					header("Authorization", "Bearer ${tokenStore.get(email)}")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}
	}

	///////////////////////////

	test("Should get association by id") {
		testApp {
			it.get("/api/associations/2") {
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
			}.apply {
				status shouldBe HttpStatusCode.OK

				body<TAssociation>().shouldBeEqualToIgnoringFields(
					TAssociation(
						id = 2,
						name = "Test Association 1",
						status = EAssociationsStatus.Enabled,
						picture = null
					),
					TAssociation::id
				)
			}
		}
	}

	mapOf(
		"admin1@hollybike.fr" to EUserScope.Admin,
		"user1@hollybike.fr" to EUserScope.User,
	).forEach { (email, scope) ->
		test("Should not get association by id if $scope") {
			testApp {
				it.get("/api/associations") {
					header("Authorization", "Bearer ${tokenStore.get(email)}")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}
	}

	test("Should not get association by id if it does not exist") {
		testApp {
			it.get("/api/associations/20") {
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
			}.apply {
				status shouldBe HttpStatusCode.NotFound

				bodyAsText() shouldBe "Association 20 inconnue"
			}
		}
	}

	///////////////////////////

	test("Should create an association") {
		testApp {
			it.post("/api/associations") {
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				contentType(ContentType.Application.Json)
				setBody(TNewAssociation(
					name = "New Association"
				))
			}.apply {
				status shouldBe HttpStatusCode.Created

				body<TAssociation>().shouldBeEqualToIgnoringFields(
					TAssociation(
						id = 0,
						name = "New Association",
						status = EAssociationsStatus.Enabled,
						picture = null
					),
					TAssociation::id
				)
			}
		}
	}

	mapOf(
		"admin1@hollybike.fr" to EUserScope.Admin,
		"user1@hollybike.fr" to EUserScope.User,
	).forEach { (email, scope) ->
		test("Should not create an association if $scope") {
			testApp {
				it.post("/api/associations") {
					header("Authorization", "Bearer ${tokenStore.get(email)}")
					contentType(ContentType.Application.Json)
					setBody(TNewAssociation(
						name = "New Association"
					))
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}
	}

	test("Should not create an association if the name already exists") {
		testApp {
			it.post("/api/associations") {
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				contentType(ContentType.Application.Json)
				setBody(TNewAssociation(
					name = "Test Association 1"
				))
			}.apply {
				status shouldBe HttpStatusCode.Conflict

				bodyAsText() shouldBe "L'association existe déjà"
			}
		}
	}

	///////////////////////////

	test("Should update an association") {
		testApp {
			it.patch("/api/associations/2") {
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				contentType(ContentType.Application.Json)
				setBody(TUpdateAssociation(
					name = "Updated Association",
					status = EAssociationsStatus.Disabled
				))
			}.apply {
				status shouldBe HttpStatusCode.OK

				body<TAssociation>().shouldBeEqualToIgnoringFields(
					TAssociation(
						id = 2,
						name = "Updated Association",
						status = EAssociationsStatus.Disabled,
						picture = null
					),
					TAssociation::id
				)
			}
		}
	}

	mapOf(
		"admin1@hollybike.fr" to EUserScope.Admin,
		"user1@hollybike.fr" to EUserScope.User,
	).forEach { (email, scope) ->
		test("Should not update an association if $scope") {
			testApp {
				it.patch("/api/associations/2") {
					header("Authorization", "Bearer ${tokenStore.get(email)}")
					contentType(ContentType.Application.Json)
					setBody(TUpdateAssociation(
						name = "Updated Association",
						status = EAssociationsStatus.Disabled
					))
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}
	}

	test("Should not update an association if the name already exists") {
		testApp {
			it.patch("/api/associations/2") {
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				contentType(ContentType.Application.Json)
				setBody(TUpdateAssociation(
					name = "Test Association 2",
				))
			}.apply {
				status shouldBe HttpStatusCode.Conflict
				bodyAsText() shouldBe "L'association existe déjà"
			}
		}
	}

	test("Should not update an association if it does not exist") {
		testApp {
			it.patch("/api/associations/20") {
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				contentType(ContentType.Application.Json)
				setBody(TUpdateAssociation(
					name = "Updated Association",
					status = EAssociationsStatus.Disabled
				))
			}.apply {
				status shouldBe HttpStatusCode.NotFound
				bodyAsText() shouldBe "Association 20 inconnue"
			}
		}
	}

	///////////////////////////

	listOf(
		"image/jpeg",
		"image/png"
	).forEach { contentType ->
		test("Should upload association $contentType picture") {
			testApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/associations/2/picture") {
					val boundary = "WebAppBoundary"
					header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
					setBody(
						MultiPartFormDataContent(
							formData {
								append("file", file.readBytes(), Headers.build {
									append(HttpHeaders.ContentType, contentType)
									append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
								})
							},
							boundary,
							ContentType.MultiPart.FormData.withParameter("boundary", boundary)
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}
	}

	mapOf(
		"admin1@hollybike.fr" to EUserScope.Admin,
		"user1@hollybike.fr" to EUserScope.User,
	).forEach { (email, scope) ->
		test("Should not upload association picture if $scope") {
			testApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/associations/2/picture") {
					val boundary = "WebAppBoundary"
					header("Authorization", "Bearer ${tokenStore.get(email)}")
					setBody(
						MultiPartFormDataContent(
							formData {
								append("file", file.readBytes(), Headers.build {
									append(HttpHeaders.ContentType, "image/jpeg")
									append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
								})
							},
							boundary,
							ContentType.MultiPart.FormData.withParameter("boundary", boundary)
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}
	}

	listOf(
		"image/gif",
		"image/svg+xml",
		"image/webp",
		"application/javascript",
	).forEach { contentType ->
		test("Should not upload association $contentType picture") {
			testApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/associations/2/picture") {
					val boundary = "WebAppBoundary"
					header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
					setBody(
						MultiPartFormDataContent(
							formData {
								append("file", file.readBytes(), Headers.build {
									append(HttpHeaders.ContentType, contentType)
									append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
								})
							},
							boundary,
							ContentType.MultiPart.FormData.withParameter("boundary", boundary)
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest
					bodyAsText() shouldBe "Image invalide (JPEG et PNG seulement)"
				}
			}
		}
	}

	test("Should not upload association picture with no content type") {
		testApp {
			val file = File(
				javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
			)

			it.patch("/api/associations/2/picture") {
				val boundary = "WebAppBoundary"
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				setBody(
					MultiPartFormDataContent(
						formData {
							append("file", file.readBytes(), Headers.build {
								append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
							})
						},
						boundary,
						ContentType.MultiPart.FormData.withParameter("boundary", boundary)
					)
				)
			}.apply {
				status shouldBe HttpStatusCode.BadRequest
				bodyAsText() shouldBe "Type de contenu de l'image manquant"
			}
		}
	}

	test("Should not upload association picture if it does not exist") {
		testApp {
			val file = File(
				javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
			)

			it.patch("/api/associations/20/picture") {
				val boundary = "WebAppBoundary"
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				setBody(
					MultiPartFormDataContent(
						formData {
							append("file", file.readBytes(), Headers.build {
								append(HttpHeaders.ContentType, "image/jpeg")
								append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
							})
						},
						boundary,
						ContentType.MultiPart.FormData.withParameter("boundary", boundary)
					)
				)
			}.apply {
				status shouldBe HttpStatusCode.NotFound
				bodyAsText() shouldBe "Association 20 inconnue"
			}
		}
	}

	///////////////////////////

	test("Should delete an association") {
		testApp {
			it.delete("/api/associations/2") {
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
			}.apply {
				status shouldBe HttpStatusCode.OK
			}
		}
	}

	mapOf(
		"admin1@hollybike.fr" to EUserScope.Admin,
		"user1@hollybike.fr" to EUserScope.User,
	).forEach { (email, scope) ->
		test("Should not delete an association if $scope") {
			testApp {
				it.delete("/api/associations/2") {
					header("Authorization", "Bearer ${tokenStore.get(email)}")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}
	}

	test("Should not delete an association if it does not exist") {
		testApp {
			it.delete("/api/associations/20") {
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
			}.apply {
				status shouldBe HttpStatusCode.NotFound
				bodyAsText() shouldBe "Association 20 inconnue"
			}
		}
	}
})