package hollybike.api.routing.controller

import hollybike.api.isCloud
import hollybike.api.plugins.user
import hollybike.api.repository.Association
import hollybike.api.repository.User
import hollybike.api.routing.resources.API
import hollybike.api.routing.resources.Associations
import hollybike.api.routing.resources.Users
import hollybike.api.types.association.TAssociation
import hollybike.api.types.association.TNewAssociation
import hollybike.api.types.association.TUpdateAssociation
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.experimental.newSuspendedTransaction
import org.jetbrains.exposed.sql.transactions.transaction
import org.postgresql.util.PSQLException
import kotlin.math.ceil

class AssociationController(
	application: Application,
	private val db: Database
) {
	init {
		application.routing {
			authenticate {
				getMyAssociation()
				updateMyAssociation()
				if(application.isCloud) {
					getAll()
					getById()
					getByUser()
					addAssociation()
					updateAssociation()
					deleteAssociation()
				}
			}
		}
	}

	private fun Route.getMyAssociation() {
		get<Associations.Me<API>>(EUserScope.Admin) {
			call.respond(TAssociation(call.user.association))
		}
	}

	private fun Route.updateMyAssociation() {
		patch<Associations.Me<API>>(EUserScope.Admin) {
			val update = call.receive<TUpdateAssociation>()
			transaction(db) {
				update.name?.let { call.user.association.name = it }
			}
			call.respond(TAssociation(call.user.association))
		}
	}

	private fun Route.getAll() {
		get<Associations<API>>(EUserScope.Root) {
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
					totalPage = ceil(totAssociations.div(listParam.perPage.toDouble())).toInt(),
					totalData = totAssociations.toInt()
				)
			)
		}
	}

	private fun Route.getById() {
		get<Associations.Id<API>>(EUserScope.Root) {
			transaction(db) { Association.findById(it.id) }?.let {
				call.respond(TAssociation(it))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "Association ${it.id} not found")
			}
		}
	}

	private fun Route.getByUser() {
		get<Associations<Users.Id>>(EUserScope.Root) {
			transaction(db) { User.findById(it.parent.id)?.load(User::association) }?.let {
				call.respond(TAssociation(it.association))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "User not found")
			}
		}
	}

	private fun Route.addAssociation() {
		post<Associations<API>>(EUserScope.Root) {
			val new = call.receive<TNewAssociation>()
			val association = try{
				transaction(db) {
					Association.new {
						this.name = new.name
					}
				}
			}catch (e: PSQLException) {
				if(e.serverErrorMessage?.constraint == "associations_name_uindex" && e.serverErrorMessage?.detail?.contains("already exists") == true) {
					call.respond(HttpStatusCode.Conflict, "Associations already exist")
				} else {
					e.printStackTrace()
					call.respond(HttpStatusCode.InternalServerError, "Internal server error")
				}
				return@post
			}
			call.respond(HttpStatusCode.Created, TAssociation(association))
		}
	}

	private fun Route.updateAssociation() {
		patch<Associations.Id<API>>(EUserScope.Root) {
			val update = call.receive<TUpdateAssociation>()
			newSuspendedTransaction(db = db) {
				val association = Association.findById(it.id) ?: run {
					call.respond(HttpStatusCode.NotFound, "Association ${it.id} not found")
					return@newSuspendedTransaction
				}
				update.name?.let { association.name = it }
				update.status?.let { association.status = it }
				call.respond(TAssociation(association))
			}
		}
	}

	private fun Route.deleteAssociation() {
		delete<Associations.Id<API>>(EUserScope.Root) {
			val deleted = transaction(db = db) {
				val association = Association.findById(it.id) ?: run {
					return@transaction false
				}
				association.delete()
				return@transaction true
			}
			if(deleted) {
				call.respond(HttpStatusCode.NoContent)
			} else {
				call.respond(HttpStatusCode.NotFound, "Association ${it.id} not found")
			}
		}
	}
}