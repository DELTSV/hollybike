package hollybike.api.routing.controller

import hollybike.api.services.AssociationService
import hollybike.api.exceptions.AssociationAlreadyExists
import hollybike.api.exceptions.AssociationNotFound
import hollybike.api.isCloud
import hollybike.api.plugins.user
import hollybike.api.repository.associationMapper
import hollybike.api.routing.resources.API
import hollybike.api.routing.resources.Associations
import hollybike.api.services.storage.StorageService
import hollybike.api.types.association.TAssociation
import hollybike.api.types.association.TNewAssociation
import hollybike.api.types.association.TUpdateAssociation
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.*
import hollybike.api.utils.search.getMapperData
import hollybike.api.utils.search.getSearchParam
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlin.math.ceil

class AssociationController(
	application: Application,
	private val associationService: AssociationService,
	private val storageService: StorageService
) {
	init {
		application.routing {
			authenticate {
				getMyAssociation()
				updateMyAssociation()
				updateMyAssociationPicture()

				if (application.isCloud) {
					getAll()
					getMetaData()
					getById()
					addAssociation()
					updateAssociation()
					updateAssociationPicture()
					deleteAssociation()
				}
			}
		}
	}

	private fun Route.getMyAssociation() {
		get<Associations.Me<API>>(EUserScope.Admin) {
			call.respond(TAssociation(call.user.association, storageService.signer.sign))
		}
	}

	private fun Route.updateMyAssociation() {
		patch<Associations.Me<API>>(EUserScope.Admin) {
			val update = call.receive<TUpdateAssociation>()
			associationService.updateAssociation(
				call.user.association.id.value,
				update.name,
				null
			).onSuccess {
				call.respond(TAssociation(it, storageService.signer.sign))
			}.onFailure {
				when (it) {
					is AssociationAlreadyExists -> call.respond(HttpStatusCode.Conflict, "L'association existe déjà")
					else -> call.respond(HttpStatusCode.InternalServerError, "Erreur serveur interne")
				}
			}
		}
	}

	private fun Route.updateMyAssociationPicture() {
		patch<Associations.Me.Picture<API>>(EUserScope.Admin) {
			val multipart = call.receiveMultipart()

			val image = multipart.readPart() as PartData.FileItem

			val contentType = image.contentType ?: run {
				call.respond(HttpStatusCode.BadRequest, "Type de contenu de l'image manquant")
				return@patch
			}

			if (contentType != ContentType.Image.JPEG && contentType != ContentType.Image.PNG) {
				call.respond(HttpStatusCode.BadRequest, "Image invalide (JPEG et PNG seulement)")
				return@patch
			}

			val association = associationService.updateMyAssociationPicture(
				call.user.association,
				image.streamProvider().readBytes(),
				contentType
			)

			call.respond(TAssociation(association, storageService.signer.sign))
		}
	}

	private fun Route.getAll() {
		get<Associations<API>>(EUserScope.Root) {
			val searchParam = call.request.queryParameters.getSearchParam(associationMapper)
			val associations = associationService.getAll(call.user, searchParam).getOrElse {
				call.respond(HttpStatusCode.Forbidden)
				return@get
			}
			val totAssociations = associationService.countAssociations(call.user, searchParam).getOrElse {
				call.respond(HttpStatusCode.Forbidden)
				return@get
			}

			call.respond(
				TLists(
					data = associations.map { TAssociation(it, storageService.signer.sign) },
					page = searchParam.page,
					perPage = searchParam.perPage,
					totalPage = ceil(totAssociations.div(searchParam.perPage.toDouble())).toInt(),
					totalData = totAssociations
				)
			)
		}
	}

	private fun Route.getById() {
		get<Associations.Id<API>>(EUserScope.Root) { params ->
			associationService.getById(params.id)?.let {
				call.respond(TAssociation(it, storageService.signer.sign))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "Association ${params.id} inconnue")
			}
		}
	}

	private fun Route.addAssociation() {
		post<Associations<API>>(EUserScope.Root) {
			val new = call.receive<TNewAssociation>()

			associationService.createAssociation(new.name).onSuccess {
				call.respond(HttpStatusCode.Created, TAssociation(it, storageService.signer.sign))
			}.onFailure {
				when (it) {
					is AssociationAlreadyExists -> call.respond(HttpStatusCode.Conflict, "L'association existe déjà")
					else -> call.respond(HttpStatusCode.InternalServerError, "Erreur serveur interne")
				}
			}
		}
	}

	private fun Route.updateAssociation() {
		patch<Associations.Id<API>>(EUserScope.Root) { params ->
			val update = call.receive<TUpdateAssociation>()

			associationService.updateAssociation(
				params.id,
				update.name,
				update.status
			).onSuccess {
				call.respond(TAssociation(it, storageService.signer.sign))
			}.onFailure {
				when (it) {
					is AssociationNotFound -> call.respond(
						HttpStatusCode.NotFound,
						"Association ${params.id} inconnue"
					)

					is AssociationAlreadyExists -> call.respond(
						HttpStatusCode.Conflict,
						"L'association existe déjà"
					)

					else -> call.respond(HttpStatusCode.InternalServerError, "Erreur serveur interne")
				}
			}
		}
	}

	private fun Route.updateAssociationPicture() {
		patch<Associations.Id.Picture<API>>(EUserScope.Root) { params ->
			val multipart = call.receiveMultipart()

			val image = multipart.readPart() as PartData.FileItem

			val contentType = image.contentType ?: run {
				call.respond(HttpStatusCode.BadRequest, "Type de contenu de l'image manquant")
				return@patch
			}

			if (contentType != ContentType.Image.JPEG && contentType != ContentType.Image.PNG) {
				call.respond(HttpStatusCode.BadRequest, "Image invalide (JPEG et PNG seulement)")
				return@patch
			}

			associationService.updateAssociationPicture(
				params.id.id,
				image.streamProvider().readBytes(),
				contentType
			).onSuccess {
				call.respond(TAssociation(it, storageService.signer.sign))
			}.onFailure {
				when (it) {
					is AssociationNotFound -> call.respond(
						HttpStatusCode.NotFound,
						it.message ?: "Association inconnue"
					)

					else -> call.respond(HttpStatusCode.InternalServerError, "Erreur serveur interne")
				}
			}
		}
	}

	private fun Route.deleteAssociation() {
		delete<Associations.Id<API>>(EUserScope.Root) { params ->
			associationService.deleteAssociation(params.id).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				when (it) {
					is AssociationNotFound -> call.respond(
						HttpStatusCode.NotFound,
						it.message ?: "Association inconnue"
					)

					else -> call.respond(HttpStatusCode.InternalServerError, "Erreur serveur interne")
				}
			}
		}
	}

	private fun Route.getMetaData() {
		get<Associations.MetaData<API>>(EUserScope.Root) {
			call.respond(associationMapper.getMapperData())
		}
	}
}