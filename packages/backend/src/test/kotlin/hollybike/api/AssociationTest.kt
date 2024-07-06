package hollybike.api

import hollybike.api.base.*
import hollybike.api.services.storage.StorageMode
import hollybike.api.stores.AssociationStore
import hollybike.api.stores.UserStore
import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.types.association.TAssociation
import hollybike.api.types.association.TNewAssociation
import hollybike.api.types.association.TUpdateAssociation
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserScope
import io.kotest.matchers.equality.shouldBeEqualToIgnoringFields
import io.kotest.matchers.equals.shouldBeEqual
import io.kotest.matchers.shouldBe
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.request.forms.*
import io.ktor.client.statement.*
import io.ktor.http.*
import kotlinx.datetime.Clock
import java.io.File

class AssociationTest : IntegrationSpec({
	context("Get my association") {
		test("Should return the my association") {
			onPremiseTestApp {
				it.get("/api/associations/me") {
					auth(UserStore.admin1)
				}.apply {
					status shouldBe HttpStatusCode.OK
					body<TAssociation>().shouldBeEqualToIgnoringFields(
						TAssociation(
							id = AssociationStore.association1.id,
							name = AssociationStore.association1.value,
							status = EAssociationsStatus.Enabled,
							picture = null
						),
						TAssociation::id
					)
				}
			}
		}

		test("Should not return my association if not admin") {
			onPremiseTestApp {
				it.get("/api/associations/me") {
					auth(UserStore.user1)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}
	}

	context("Update my association") {
		test("Should update my association") {
			onPremiseTestApp {
				it.patch("/api/associations/me") {
					auth(UserStore.admin1)
					contentType(ContentType.Application.Json)
					setBody(TUpdateAssociation(
						name = "Updated Association",
						status = EAssociationsStatus.Disabled
					))
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TAssociation>() shouldBeEqual TAssociation(
						id = AssociationStore.association1.id,
						name = "Updated Association",
						status = EAssociationsStatus.Enabled,
						picture = null
					)
				}
			}
		}

		test("Should not update my association if not admin") {
			onPremiseTestApp {
				it.patch("/api/associations/me") {
					auth(UserStore.user1)
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
			onPremiseTestApp {
				it.patch("/api/associations/me") {
					auth(UserStore.admin1)
					contentType(ContentType.Application.Json)
					setBody(TUpdateAssociation(
						name = AssociationStore.association2.value
					))
				}.apply {
					status shouldBe HttpStatusCode.Conflict
					bodyAsText() shouldBe "L'association existe déjà"
				}
			}
		}
	}

	context("Upload my association picture") {
		listOf(
			"image/jpeg",
			"image/png"
		).forEach { contentType ->
			listOf(
				StorageMode.S3,
				StorageMode.LOCAL,
				StorageMode.FTP
			).forEach { storageMode ->
				test("Should upload my association $contentType picture in $storageMode mode") {
					onPremiseTestApp(storageMode) {
						val file = File(
							javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
						)

						it.patch("/api/associations/me/picture") {
							val boundary = "WebAppBoundary"
							auth(UserStore.admin1)
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
		}

		test("Should not upload my association picture if not admin") {
			onPremiseTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/associations/me/picture") {
					val boundary = "WebAppBoundary"
					auth(UserStore.user1)
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
				onPremiseTestApp {
					val file = File(
						javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
					)

					it.patch("/api/associations/me/picture") {
						val boundary = "WebAppBoundary"
						auth(UserStore.admin1)
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
			onPremiseTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/associations/me/picture") {
					val boundary = "WebAppBoundary"
					auth(UserStore.admin1)
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
	}

	context("Get all associations") {
		test("Should get all associations") {
			cloudTestApp {
				it.get("/api/associations?per_page=10&page=0") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TAssociation>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = nbPages(
								nbItems = AssociationStore.ASSOCIATION_COUNT,
								pageSize = 10
							),
							perPage = 10,
							totalData = AssociationStore.ASSOCIATION_COUNT.toLong()
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe countWithCap(
						cap = 10,
						count = AssociationStore.ASSOCIATION_COUNT
					)
				}
			}
		}

		mapOf(
			UserStore.admin1 to EUserScope.Admin,
			UserStore.user1 to EUserScope.User,
		).forEach { (user, scope) ->
			test("Should not get all associations if $scope") {
				cloudTestApp {
					it.get("/api/associations") {
						auth(user)
					}.apply {
						status shouldBe HttpStatusCode.Forbidden
						bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
					}
				}
			}
		}

		test("Should not get all associations if on premise mode") {
			onPremiseTestApp {
				it.get("/api/associations") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.NotFound
				}
			}
		}
	}

	context("Get association by id") {
		test("Should get association by id") {
			cloudTestApp {
				it.get("/api/associations/${AssociationStore.association1.id}") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TAssociation>().shouldBeEqualToIgnoringFields(
						TAssociation(
							id = AssociationStore.association1.id,
							name = AssociationStore.association1.value,
							status = EAssociationsStatus.Enabled,
							picture = null
						),
						TAssociation::id
					)
				}
			}
		}

		mapOf(
			UserStore.admin1 to EUserScope.Admin,
			UserStore.user1 to EUserScope.User,
		).forEach { (user, scope) ->
			test("Should not get association by id if $scope") {
				cloudTestApp {
					it.get("/api/associations") {
						auth(user)
					}.apply {
						status shouldBe HttpStatusCode.Forbidden
						bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
					}
				}
			}
		}

		test("Should not get association by id if it does not exist") {
			cloudTestApp {
				it.get("/api/associations/${AssociationStore.unknown.id}") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Association ${AssociationStore.unknown.id} inconnue"
				}
			}
		}

		test("Should get association by id if on premise mode") {
			onPremiseTestApp {
				it.get("/api/associations/${AssociationStore.association1.id}") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not get other association by id if on premise mode") {
			onPremiseTestApp {
				it.get("/api/associations/${AssociationStore.unknown.id}") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.NotFound
				}
			}
		}
	}

	context("Create new association") {
		test("Should create an association") {
			cloudTestApp {
				it.post("/api/associations") {
					auth(UserStore.root)
					contentType(ContentType.Application.Json)
					setBody(TNewAssociation(
						name = AssociationStore.new.value
					))
				}.apply {
					status shouldBe HttpStatusCode.Created

					body<TAssociation>().shouldBeEqualToIgnoringFields(
						TAssociation(
							id = AssociationStore.new.id,
							name = AssociationStore.new.value,
							status = EAssociationsStatus.Enabled,
							picture = null
						),
						TAssociation::id
					)
				}
			}
		}

		mapOf(
			UserStore.admin1 to EUserScope.Admin,
			UserStore.user1 to EUserScope.User,
		).forEach { (user, scope) ->
			test("Should not create an association if $scope") {
				cloudTestApp {
					it.post("/api/associations") {
						auth(user)
						contentType(ContentType.Application.Json)
						setBody(TNewAssociation(
							name = AssociationStore.new.value
						))
					}.apply {
						status shouldBe HttpStatusCode.Forbidden

						bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
					}
				}
			}
		}

		test("Should not create an association if the name already exists") {
			cloudTestApp {
				it.post("/api/associations") {
					auth(UserStore.root)
					contentType(ContentType.Application.Json)
					setBody(TNewAssociation(
						name = AssociationStore.association1.value
					))
				}.apply {
					status shouldBe HttpStatusCode.Conflict

					bodyAsText() shouldBe "L'association existe déjà"
				}
			}
		}

		test("Should not create an association if on premise mode") {
			onPremiseTestApp {
				it.post("/api/associations") {
					auth(UserStore.root)
					contentType(ContentType.Application.Json)
					setBody(TNewAssociation(
						name = AssociationStore.new.value
					))
				}.apply {
					status shouldBe HttpStatusCode.NotFound
				}
			}
		}
	}

	context("Update an association") {
		test("Should update an association") {
			cloudTestApp {
				it.patch("/api/associations/${AssociationStore.association1.id}") {
					auth(UserStore.root)
					contentType(ContentType.Application.Json)
					setBody(TUpdateAssociation(
						name = "Updated Association",
						status = EAssociationsStatus.Disabled
					))
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TAssociation>().shouldBeEqualToIgnoringFields(
						TAssociation(
							id = AssociationStore.association1.id,
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
			UserStore.admin1 to EUserScope.Admin,
			UserStore.user1 to EUserScope.User,
		).forEach { (user, scope) ->
			test("Should not update an association if $scope") {
				cloudTestApp {
					it.patch("/api/associations/2") {
						auth(user)
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
			cloudTestApp {
				it.patch("/api/associations/${AssociationStore.association1.id}") {
					auth(UserStore.root)
					contentType(ContentType.Application.Json)
					setBody(TUpdateAssociation(
						name = AssociationStore.association2.value
					))
				}.apply {
					status shouldBe HttpStatusCode.Conflict
					bodyAsText() shouldBe "L'association existe déjà"
				}
			}
		}

		test("Should not update an association if it does not exist") {
			cloudTestApp {
				it.patch("/api/associations/${AssociationStore.unknown.id}") {
					auth(UserStore.root)
					contentType(ContentType.Application.Json)
					setBody(TUpdateAssociation(
						name = "Updated Association",
						status = EAssociationsStatus.Disabled
					))
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Association ${AssociationStore.unknown.id} inconnue"
				}
			}
		}

		test("Should not update an association if on premise mode") {
			onPremiseTestApp {
				it.patch("/api/associations/${AssociationStore.association1.id}") {
					auth(UserStore.root)
					contentType(ContentType.Application.Json)
					setBody(TUpdateAssociation(
						name = "Updated Association",
						status = EAssociationsStatus.Disabled
					))
				}.apply {
					status shouldBe HttpStatusCode.NotFound
				}
			}
		}
	}

	context("Upload association picture") {
		listOf(
			"image/jpeg",
			"image/png"
		).forEach { contentType ->
			test("Should upload association $contentType picture") {
				cloudTestApp {
					val file = File(
						javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
					)

					it.patch("/api/associations/${AssociationStore.association1.id}/picture") {
						val boundary = "WebAppBoundary"
						auth(UserStore.root)
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
			UserStore.admin1 to EUserScope.Admin,
			UserStore.user1 to EUserScope.User,
		).forEach { (user, scope) ->
			test("Should not upload association picture if $scope") {
				cloudTestApp {
					val file = File(
						javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
					)

					it.patch("/api/associations/${AssociationStore.association1.id}/picture") {
						val boundary = "WebAppBoundary"
						auth(user)
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
				cloudTestApp {
					val file = File(
						javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
					)

					it.patch("/api/associations/${AssociationStore.association1.id}/picture") {
						val boundary = "WebAppBoundary"
						auth(UserStore.root)
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
			cloudTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/associations/${AssociationStore.association1.id}/picture") {
					val boundary = "WebAppBoundary"
					auth(UserStore.root)
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
			cloudTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/associations/${AssociationStore.unknown.id}/picture") {
					val boundary = "WebAppBoundary"
					auth(UserStore.root)
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
					bodyAsText() shouldBe "Association ${AssociationStore.unknown.id} inconnue"
				}
			}
		}

		test("Should not upload association picture if on premise mode") {
			onPremiseTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/associations/${AssociationStore.unknown.id}/picture") {
					val boundary = "WebAppBoundary"
					auth(UserStore.root)
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
				}
			}
		}
	}

	context("Delete an association") {
		test("Should delete an association") {
			cloudTestApp {
				it.delete("/api/associations/${AssociationStore.association1.id}") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		mapOf(
			UserStore.admin1 to EUserScope.Admin,
			UserStore.user1 to EUserScope.User,
		).forEach { (user, scope) ->
			test("Should not delete an association if $scope") {
				cloudTestApp {
					it.delete("/api/associations/${AssociationStore.association1.id}") {
						auth(user)
					}.apply {
						status shouldBe HttpStatusCode.Forbidden

						bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
					}
				}
			}
		}

		test("Should not delete an association if it does not exist") {
			cloudTestApp {
				it.delete("/api/associations/${AssociationStore.unknown.id}") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Association ${AssociationStore.unknown.id} inconnue"
				}
			}
		}

		test("Should not delete an association in on premise mode") {
			onPremiseTestApp {
				it.delete("/api/associations/${AssociationStore.association1.id}") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.NotFound
				}
			}
		}
	}
})