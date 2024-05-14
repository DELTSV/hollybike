package hollybike.api.services

import hollybike.api.exceptions.AssociationAlreadyExists
import hollybike.api.exceptions.AssociationNotFound
import hollybike.api.repository.Association
import hollybike.api.repository.User
import hollybike.api.repository.Users
import hollybike.api.services.storage.StorageService
import hollybike.api.types.association.EAssociationsStatus
import io.ktor.http.*
import org.jetbrains.exposed.exceptions.ExposedSQLException
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction
import org.postgresql.util.PSQLException
import java.sql.BatchUpdateException

class AssociationService(
	private val db: Database,
	private val storageService: StorageService,
) {
	private fun checkAlreadyExistsException(e: ExposedSQLException): Boolean {
		val cause = if (e.cause is BatchUpdateException && (e.cause as BatchUpdateException).cause is PSQLException) {
			(e.cause as BatchUpdateException).cause as PSQLException
		} else if (e.cause is PSQLException) {
			e.cause as PSQLException
		} else {
			return false
		}

		return if (
			cause.serverErrorMessage?.constraint == "associations_name_uindex" &&
			cause.serverErrorMessage?.detail?.contains("already exists") == true
		) {
			true
		} else {
			e.printStackTrace()
			false
		}
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

	fun getAll(page: Int, perPage: Int): List<Association> = transaction(db) {
		Association.all().limit(perPage, offset = (page * perPage).toLong())
			.toList()
	}

	fun countAssociations(): Int = transaction(db) {
		Association.all().count().toInt()
	}

	fun getById(id: Int): Association? = transaction(db) {
		Association.findById(id)
	}

	fun createAssociation(name: String): Result<Association> {
		return try {
			transaction(db) {
				Result.success(
					Association.new {
						this.name = name
					}
				)
			}
		} catch (e: ExposedSQLException) {
			if (checkAlreadyExistsException(e)) {
				return Result.failure(AssociationAlreadyExists())
			}

			return Result.failure(e)
		}
	}

	fun updateAssociation(id: Int, name: String?, status: EAssociationsStatus?): Result<Association> {
		return try {
			transaction {
				val association = Association.findById(id) ?: run {
					return@transaction Result.failure(AssociationNotFound("Association not found"))
				}
				name?.let { association.name = it }
				status?.let { association.status = it }

				Result.success(association)
			}
		} catch (e: ExposedSQLException) {
			if (checkAlreadyExistsException(e)) {
				return Result.failure(AssociationAlreadyExists())
			}

			return Result.failure(e)
		}
	}

	suspend fun updateAssociationPicture(id: Int, image: ByteArray, contentType: ContentType): Result<Association> {
		val path = "a/$id/p"
		storageService.store(image, path, contentType.contentType)

		return transaction {
			val association = Association.findById(id) ?: run {
				return@transaction Result.failure(AssociationNotFound("Association $id inconnue"))
			}
			association.picture = path

			Result.success(association)
		}
	}

	fun deleteAssociation(id: Int): Result<Unit> = transaction {
		val association = Association.findById(id) ?: run {
			return@transaction Result.failure(AssociationNotFound("Association $id inconnue"))
		}

		User.find { Users.association eq association.id.value }.forEach { it.delete() }

		association.delete()

		return@transaction Result.success(Unit)
	}
}