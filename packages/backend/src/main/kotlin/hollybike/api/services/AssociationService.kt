package hollybike.api.services

import hollybike.api.exceptions.AssociationAlreadyExists
import hollybike.api.exceptions.AssociationNotFound
import hollybike.api.exceptions.NotAllowedException
import hollybike.api.repository.Association
import hollybike.api.repository.Associations
import hollybike.api.repository.User
import hollybike.api.services.storage.StorageService
import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import io.ktor.http.*
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.selectAll
import org.jetbrains.exposed.sql.transactions.transaction
import org.postgresql.util.PSQLException

class AssociationService(
	private val db: Database,
	private val storageService: StorageService,
) {
	fun updateMyAssociation(association: Association, name: String?): Association = transaction(db) {
		name?.let { association.name = it }

		association
	}

	suspend fun updateMyAssociationPicture(
		association: Association,
		image: ByteArray,
		contentType: ContentType
	): Association {
		val path = "a/${association.id}/p"
		storageService.store(image, path, contentType.contentType)
		transaction(db) { association.picture = path }

		return association
	}

	fun getAll(caller: User, searchParam: SearchParam): Result<List<Association>> = transaction(db) {
		if(caller.scope not EUserScope.Root) {
			return@transaction Result.failure(NotAllowedException())
		}
		Result.success(Association.wrapRows(Associations.selectAll().applyParam(searchParam)).toList())
	}

	fun countAssociations(caller: User, searchParam: SearchParam): Result<Int> = transaction(db) {
		if(caller.scope not EUserScope.Root) {
			return@transaction Result.failure(NotAllowedException())
		}
		Result.success(Associations.selectAll().applyParam(searchParam, false).count().toInt())
	}

	fun getById(id: Int): Association? = transaction(db) {
		Association.findById(id)
	}

	fun getByUser(userId: Int): Association? = transaction(db) {
		User.findById(userId)?.load(User::association)
	}?.association

	fun createAssociation(name: String): Result<Association> {
		return try {
			transaction(db) {
				Result.success(
					Association.new {
						this.name = name
					}
				)
			}
		} catch (e: PSQLException) {
			return if (e.serverErrorMessage?.constraint == "associations_name_uindex" && e.serverErrorMessage?.detail?.contains(
					"already exists"
				) == true
			) {
				Result.failure(AssociationAlreadyExists())
			} else {
				e.printStackTrace()
				Result.failure(e)
			}
		}
	}

	fun updateAssociation(id: Int, name: String?, status: EAssociationsStatus?): Result<Association> = transaction {
		val association = Association.findById(id) ?: run {
			return@transaction Result.failure(AssociationNotFound("Association not found"))
		}
		name?.let { association.name = it }
		status?.let { association.status = it }

		Result.success(association)
	}

	suspend fun updateAssociationPicture(id: Int, image: ByteArray, contentType: ContentType): Result<Association> {
		val path = "a/$id/p"
		storageService.store(image, path, contentType.contentType)

		return transaction {
			val association = Association.findById(id) ?: run {
				return@transaction Result.failure(AssociationNotFound("Association not found"))
			}
			association.picture = path

			Result.success(association)
		}
	}

	fun deleteAssociation(id: Int): Result<Unit> = transaction {
		val association = Association.findById(id) ?: run {
			return@transaction Result.failure(AssociationNotFound("Association not found"))
		}
		association.delete()

		return@transaction Result.success(Unit)
	}
}