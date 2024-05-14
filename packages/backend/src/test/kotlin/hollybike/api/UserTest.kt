package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.services.storage.StorageMode
import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.types.association.TAssociation
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import hollybike.api.types.user.TUser
import hollybike.api.types.user.TUserUpdateSelf
import io.kotest.matchers.equality.shouldBeEqualToIgnoringFields
import io.kotest.matchers.shouldBe
import io.kotest.matchers.shouldNotBe
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.request.forms.*
import io.ktor.client.statement.*
import io.ktor.http.*
import kotlinx.datetime.Instant
import java.io.File

class UserTest : IntegrationSpec({
	context("Get association by user id") {
		test("Should get association by user id") {
			onPremiseTestApp {
				it.get("/api/users/2/association") {
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
			test("Should not get association by user id if $scope") {
				onPremiseTestApp {
					it.get("/api/users/2/association") {
						header("Authorization", "Bearer ${tokenStore.get(email)}")
					}.apply {
						status shouldBe HttpStatusCode.Forbidden
						bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
					}
				}
			}
		}

		mapOf(
			"root@hollybike.fr" to EUserScope.Root,
			"admin1@hollybike.fr" to EUserScope.Admin,
			"user1@hollybike.fr" to EUserScope.User,
		).forEach { (email, scope) ->
			run {
				test("Should return myself for role $scope") {
					onPremiseTestApp {
						it.get("/api/users/me") {
							header("Authorization", "Bearer ${tokenStore.get(email)}")
						}.apply {
							status shouldBe HttpStatusCode.OK
							val body = body<TUser>();

							body.email shouldBe email
							body.scope shouldBe scope
						}
					}
				}
			}
		}
	}

	context("Get user by id") {
		test("Should return the user by id") {
			onPremiseTestApp {
				it.get("/api/users/2") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK
					body<TUser>().shouldBeEqualToIgnoringFields(
						TUser(
							id = 1,
							email = "user1@hollybike.fr",
							username = "user1",
							scope = EUserScope.User,
							status = EUserStatus.Enabled,
							lastLogin = Instant.DISTANT_PAST,
							association = TAssociation(
								id = 2,
								name = "Test Association 1",
								status = EAssociationsStatus.Enabled,
							),
							profilePicture = null
						),
						TUser::lastLogin,
						TUser::id
					)
				}
			}
		}

		test("Should return the user by id cross association if root") {
			onPremiseTestApp {
				it.get("/api/users/2") {
					header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK
					body<TUser>().shouldBeEqualToIgnoringFields(
						TUser(
							id = 1,
							email = "user1@hollybike.fr",
							username = "user1",
							scope = EUserScope.User,
							status = EUserStatus.Enabled,
							lastLogin = Instant.DISTANT_PAST,
							association = TAssociation(
								id = 2,
								name = "Test Association 1",
								status = EAssociationsStatus.Enabled,
							),
							profilePicture = null
						),
						TUser::lastLogin,
						TUser::id
					)
				}
			}
		}

		test("Should not return the user by id if not admin") {
			onPremiseTestApp {
				it.get("/api/users/2") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}

		test("Should not found the user by id if not in the same association") {
			onPremiseTestApp {
				it.get("/api/users/4") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Utilisateur inconnu"
				}
			}
		}

		test("Should not found the user by id if it does not exist") {
			onPremiseTestApp {
				it.get("/api/users/20") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Utilisateur inconnu"
				}
			}
		}
	}

	context("Get user by email") {
		test("Should return the user by email") {
			onPremiseTestApp {
				it.get("/api/users/email/user1@hollybike.fr") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK
					body<TUser>().shouldBeEqualToIgnoringFields(
						TUser(
							id = 1,
							email = "user1@hollybike.fr",
							username = "user1",
							scope = EUserScope.User,
							status = EUserStatus.Enabled,
							lastLogin = Instant.DISTANT_PAST,
							association = TAssociation(
								id = 2,
								name = "Test Association 1",
								status = EAssociationsStatus.Enabled,
							),
							profilePicture = null
						),
						TUser::lastLogin,
						TUser::id
					)
				}
			}
		}

		test("Should return the user by email cross association if root") {
			onPremiseTestApp {
				it.get("/api/users/email/user1@hollybike.fr") {
					header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK
					body<TUser>().shouldBeEqualToIgnoringFields(
						TUser(
							id = 1,
							email = "user1@hollybike.fr",
							username = "user1",
							scope = EUserScope.User,
							status = EUserStatus.Enabled,
							lastLogin = Instant.DISTANT_PAST,
							association = TAssociation(
								id = 2,
								name = "Test Association 1",
								status = EAssociationsStatus.Enabled,
							),
							profilePicture = null
						),
						TUser::lastLogin,
						TUser::id
					)
				}
			}
		}

		test("Should not return the user by email if not admin") {
			onPremiseTestApp {
				it.get("/api/users/email/user1@hollybike.fr") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}

		test("Should not found the user by email if not in the same association") {
			onPremiseTestApp {
				it.get("/api/users/email/user3@hollybike.fr") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Utilisateur inconnu"
				}
			}
		}

		test("Should not found the user by email if it does not exist") {
			onPremiseTestApp {
				it.get("/api/users/email/notexists@hollybike.fr") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Utilisateur inconnu"
				}
			}
		}
	}

	context("Get user by username") {
		test("Should return the user by username") {
			onPremiseTestApp {
				it.get("/api/users/username/user1") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK
					body<TUser>().shouldBeEqualToIgnoringFields(
						TUser(
							id = 1,
							email = "user1@hollybike.fr",
							username = "user1",
							scope = EUserScope.User,
							status = EUserStatus.Enabled,
							lastLogin = Instant.DISTANT_PAST,
							association = TAssociation(
								id = 2,
								name = "Test Association 1",
								status = EAssociationsStatus.Enabled,
							),
							profilePicture = null
						),
						TUser::lastLogin,
						TUser::id
					)
				}
			}
		}

		test("Should return the user by username cross association if root") {
			onPremiseTestApp {
				it.get("/api/users/username/user1") {
					header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK
					body<TUser>().shouldBeEqualToIgnoringFields(
						TUser(
							id = 1,
							email = "user1@hollybike.fr",
							username = "user1",
							scope = EUserScope.User,
							status = EUserStatus.Enabled,
							lastLogin = Instant.DISTANT_PAST,
							association = TAssociation(
								id = 2,
								name = "Test Association 1",
								status = EAssociationsStatus.Enabled,
							),
							profilePicture = null
						),
						TUser::lastLogin,
						TUser::id
					)
				}
			}
		}

		test("Should not return the user by username if not admin") {
			onPremiseTestApp {
				it.get("/api/users/username/user1") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}

		test("Should not found the user by username if not in the same association") {
			onPremiseTestApp {
				it.get("/api/users/username/user3") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Utilisateur inconnu"
				}
			}
		}

		test("Should not found the user by username if it does not exist") {
			onPremiseTestApp {
				it.get("/api/users/username/notexists") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Utilisateur inconnu"
				}
			}
		}
	}

	context("Update myself") {
		test("Should update my username") {
			onPremiseTestApp {
				it.patch("/api/users/me") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUserUpdateSelf(
							username = "user-modified"
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.OK
					body<TUser>().username shouldBe "user-modified"
				}
			}
		}

		test("Should update my password") {
			onPremiseTestApp {
				it.patch("/api/users/me") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUserUpdateSelf(
							oldPassword = "test",
							newPassword = "newpassword",
							newPasswordAgain = "newpassword"
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not update my password if the old password is wrong") {
			onPremiseTestApp {
				it.patch("/api/users/me") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUserUpdateSelf(
							oldPassword = "wrongpassword",
							newPassword = "newpassword",
							newPasswordAgain = "newpassword"
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.Unauthorized
					bodyAsText() shouldBe "Mauvais old_password"
				}
			}
		}

		test("Should not update my password if the new password is different") {
			onPremiseTestApp {
				it.patch("/api/users/me") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUserUpdateSelf(
							oldPassword = "test",
							newPassword = "newpassword",
							newPasswordAgain = "differentpassword"
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest
					bodyAsText() shouldBe "new_password et _new_password_again sont différent"
				}
			}
		}

		listOf(
			TUserUpdateSelf(
				newPassword = "newpassword",
				newPasswordAgain = "differentpassword"
			),
			TUserUpdateSelf(
				newPassword = "newpassword",
			),
			TUserUpdateSelf(
				oldPassword = "test",
				newPassword = "newpassword",
			)
		).forEach { update ->
			test("Should not update my password because one element is missing") {
				onPremiseTestApp {
					it.patch("/api/users/me") {
						header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
						contentType(ContentType.Application.Json)
						setBody(update)
					}.apply {
						status shouldBe HttpStatusCode.BadRequest
						bodyAsText() shouldBe "Changer de mot de passe nécessite new_password, new_password_again et old_password"
					}
				}
			}
		}
	}

	context("Upload my profile picture") {
		listOf(
			"image/jpeg",
			"image/png"
		).forEach { contentType ->
			listOf(
				StorageMode.S3,
				StorageMode.LOCAL,
				StorageMode.FTP
			).forEach { storageMode ->
				test("Should upload my profile $contentType picture in $storageMode mode") {
					onPremiseTestApp(storageMode) {
						val file = File(
							javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
						)

						it.post("/api/users/me/profile-picture") {
							val boundary = "WebAppBoundary"
							header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
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

		listOf(
			"image/gif",
			"image/svg+xml",
			"image/webp",
			"application/javascript",
		).forEach { contentType ->
			test("Should not upload my profile $contentType picture") {
				onPremiseTestApp {
					val file = File(
						javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
					)

					it.post("/api/users/me/profile-picture") {
						val boundary = "WebAppBoundary"
						header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
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

		test("Should not upload my profile picture with no content type") {
			onPremiseTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.post("/api/users/me/profile-picture") {
					val boundary = "WebAppBoundary"
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
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

	context("Upload user profile picture by id") {
		listOf(
			"image/jpeg",
			"image/png"
		).forEach { contentType ->
			test("Should upload user profile $contentType picture by id") {
				onPremiseTestApp {
					val file = File(
						javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
					)

					it.post("/api/users/2/profile-picture") {
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

		listOf(
			"image/gif",
			"image/svg+xml",
			"image/webp",
			"application/javascript",
		).forEach { contentType ->
			test("Should not upload user profile $contentType picture by id") {
				onPremiseTestApp {
					val file = File(
						javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
					)

					it.post("/api/users/2/profile-picture") {
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

		test("Should not upload user profile picture with no content type by id") {
			onPremiseTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.post("/api/users/2/profile-picture") {
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

		test("Should not upload user profile picture if the user does not exist") {
			onPremiseTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.post("/api/users/20/profile-picture") {
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
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Utilisateur 20 inconnu"
				}
			}
		}

		test("Should not upload user profile picture if the user is not in the same association") {
			onPremiseTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.post("/api/users/4/profile-picture") {
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
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Utilisateur 4 inconnu"
				}
			}
		}

		test("Should not upload user profile picture if the user is not admin") {
			onPremiseTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.post("/api/users/2/profile-picture") {
					val boundary = "WebAppBoundary"
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
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
					status shouldBe HttpStatusCode.Forbidden
					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}
	}

	context("Get all users") {
		test("Should return list of association users") {
			onPremiseTestApp {
				it.get("/api/users") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK
					body<TLists<TUser>>().shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = 1,
							perPage = 20,
							totalData = 4
						),
						TLists<TUser>::data
					)

					body<TLists<TUser>>().data.size shouldBe 4
				}
			}
		}

		test("Should return all users if root") {
			onPremiseTestApp {
				it.get("/api/users") {
					header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK
					val body = body<TLists<TUser>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = 1,
							perPage = 20,
							totalData = 13
						),
						TLists<TUser>::data
					)

					body.data.size shouldBe 13
				}
			}
		}

		test("Should not return list of association users if not admin") {
			onPremiseTestApp {
				it.get("/api/users") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}
	}

	context("User meta-data") {
		test("Should get user meta-data") {
			onPremiseTestApp {
				it.get("/api/users/meta-data") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK
					body<Map<String, String>>().size shouldNotBe 0
				}
			}
		}

		test("Should not get user meta-data if not admin") {
			onPremiseTestApp {
				it.get("/api/users/meta-data") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}
	}
})