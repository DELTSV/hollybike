package hollybike.api.routing.controller

import hollybike.api.repository.Association
import hollybike.api.repository.User
import hollybike.api.routing.resources.API
import hollybike.api.routing.resources.Associations
import hollybike.api.routing.resources.Users
import hollybike.api.types.association.TAssociation
import hollybike.api.types.lists.TLists
import hollybike.api.utils.listParams
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction

class AssociationController(
	application: Application,
	private val db: Database
) {
	init {
		application.routing {
			getAll()
			getById()
			getByUser()
		}
	}

	private fun Route.getAll() {
		get<Associations<API>> {
			val listParam = call.listParams
			val associations = transaction(db) {
				Association.all().limit(listParam.perPage, offset = (listParam.page * listParam.perPage).toLong()).toList()
			}
			val totAssociations = transaction(db) { Association.count() }
			call.respond(
				TLists(
					data = associations.map { TAssociation(it) },
					page = listParam.page,
					perPage = listParam.perPage,
					totalPage = totAssociations.floorDiv(listParam.perPage).toInt(),
					totalData = totAssociations.toInt()
				)
			)
		}
	}

	private fun Route.getById() {
		get<Associations.Id<API>> {
			transaction(db) { Association.findById(it.id) }?.let {
				call.respond(TAssociation(it))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "Association ${it.id} not found")
			}
		}
	}

	private fun Route.getByUser() {
		get<Associations<Users.Id>> {
			transaction(db) { User.findById(it.parent.id)?.load(User::association) }?.let {
				call.respond(TAssociation(it.association))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "User not found")
			}
		}
	}
}