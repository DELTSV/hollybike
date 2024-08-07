/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services

import aws.smithy.kotlin.runtime.text.encoding.encodeBase64String
import de.nycode.bcrypt.hash
import de.nycode.bcrypt.verify
import hollybike.api.exceptions.*
import hollybike.api.repository.*
import hollybike.api.services.storage.StorageService
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import hollybike.api.types.user.TUserUpdate
import hollybike.api.types.user.TUserUpdateSelf
import hollybike.api.utils.search.Filter
import hollybike.api.utils.search.FilterMode
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import hollybike.api.utils.validPassword
import io.ktor.util.*
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.exceptions.ExposedSQLException
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.and
import org.jetbrains.exposed.sql.selectAll
import org.jetbrains.exposed.sql.transactions.transaction
import org.postgresql.util.PSQLException
import java.sql.BatchUpdateException
import java.util.*


class UserService(
	private val db: Database,
	private val storageService: StorageService,
	private val associationService: AssociationService
) {
	private fun authorizeGet(caller: User, target: User) = when(caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> caller.association.id == target.association.id
		EUserScope.User -> caller.id == target.id
	}

	private infix fun User?.getIfAllowed(caller: User): User? = if(this != null && authorizeGet(caller, this)) this else null

	private fun authorizeUpdate(caller: User, target: User, update: TUserUpdate) = when (caller.scope){
		EUserScope.Root -> true
		EUserScope.Admin -> caller.association.id == target.association.id &&
			update.association == caller.association.id.value &&
			caller.scope atLeast update.scope
		else -> false
	}

	private fun authorizeUpdatePicture(caller: User, target: User) = when (caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> caller.association.id == target.association.id
		EUserScope.User -> caller.id == target.id
	}

	private fun authorizeDelete(caller: User, target: User): Boolean = when(caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> caller.association.id == target.association.id
		EUserScope.User -> false
	}

	fun getUser(caller: User, id: Int): User? = transaction(db) {
		User.find { Users.id eq id }.with(User::association).singleOrNull() getIfAllowed caller
	}

	suspend fun uploadUserProfilePicture(
		caller: User,
		user: User,
		image: ByteArray,
		imageContentType: String,
	): String? {
		if (!authorizeUpdatePicture(caller, user)) {
			return null
		}

		try {
			user.profilePicture?.let { storageService.delete(it) }
		} catch (e: Exception) {
			e.printStackTrace()
		}

		val uuid = UUID.randomUUID().toString()
		val path = "u/${user.id}/p-$uuid"
		storageService.store(image, path, imageContentType)

		transaction(db) { user.profilePicture = path }
		return path
	}

	fun createUser(
		email: String,
		password: String,
		username: String,
		associationId: Int,
		role: EUserScope
	): Result<User> {
		val association = transaction(db) { Association.findById(associationId) } ?: run {
			return Result.failure(AssociationNotFound())
		}

		password.validPassword().onFailure {
			return Result.failure(it)
		}

		return try {
			transaction(db) {
				Result.success(
					User.new {
						this.email = email.lowercase()
						this.password = hash(password).encodeBase64String()
						this.username = username
						this.association = association
						this.scope = role
						this.status = EUserStatus.Enabled
						this.lastLogin = Clock.System.now()
					}
				)
			}
		} catch (e: ExposedSQLException) {
			if (e.cause is BatchUpdateException && (e.cause as BatchUpdateException).cause is PSQLException) {
				val cause = (e.cause as BatchUpdateException).cause as PSQLException
				if (
					cause.serverErrorMessage?.constraint == "users_email_uindex" &&
					cause.serverErrorMessage?.detail?.contains("already exists") == true
				) {
					return Result.failure(UserAlreadyExists())
				}
			}
			e.printStackTrace()
			return Result.failure(Exception())
		}
	}

	fun getUserByEmail(caller: User, email: String): User? = transaction(this.db) {
		User.find { Users.email eq email }.with(User::association).singleOrNull() getIfAllowed caller
	}

	fun getUserByEmailAndAssociation(caller: User, email: String, association: Int): User? = transaction(db) {
		User.find { (Users.email eq email) and (Users.association eq association) }.singleOrNull() getIfAllowed caller
	}

	fun getUserByUsername(caller: User, username: String): User? = transaction(db) {
		User.find { Users.username eq username }.with(User::association).singleOrNull() getIfAllowed caller
	}

	fun updateMe(user: User, update: TUserUpdateSelf): Result<User> = transaction(db) {
		user.apply {
			update.newPassword?.let {
				it.validPassword().onFailure {  e ->
					return@transaction Result.failure(e)
				}
				if ((update.newPasswordAgain == null || update.oldPassword == null)) {
					return@transaction Result.failure(BadRequestException())
				}
				if (update.newPassword != update.newPasswordAgain) {
					return@transaction Result.failure(UserDifferentNewPassword())
				}
				if (!verify(update.oldPassword, password.decodeBase64Bytes())) {
					return@transaction Result.failure(UserWrongPassword())
				}
				password = hash(it).encodeBase64()
			}
			update.username?.let { username = it }
			update.role?.let { role = it }
		}
		return@transaction Result.success(user)
	}

	fun updateUser(caller: User, user: User, update: TUserUpdate): Result<User> {
		if (!authorizeUpdate(caller, user, update)) {
			return Result.failure(NotAllowedException("Opération impossible"))
		}
		if(getUserByEmailAndAssociation(caller, user.email, caller.association.id.value) == null) {
			return Result.failure(UserNotFoundException())
		}
		update.password?.validPassword()?.onFailure {
			return Result.failure(it)
		}
		val targetAssociation = update.association?.let {
			associationService.getById(caller, it)
		}
		return transaction(db) {
			Result.success(user.apply {
				update.username?.let { username = it }
				update.email?.let { email = it }
				update.password?.let { password = hash(it).encodeBase64() }
				update.status?.let { status = it }
				update.scope?.let { scope = it }
				targetAssociation?.let { association = it }
				update.role?.let { role = it }
			})
		}
	}

	fun getAll(caller: User, searchParam: SearchParam): List<User>? {
		if (caller.scope == EUserScope.User) {
			return null
		}
		val param = searchParam.copy(filter = searchParam.filter.toMutableList())
		if (caller.scope not EUserScope.Root) {
			param.filter.add(Filter(Associations.id, caller.association.id.value.toString(), FilterMode.EQUAL))
		}
		return transaction(db) {
			User.wrapRows(Users.innerJoin(Associations).selectAll().applyParam(param)).with(User::association).toList()
		}
	}

	fun getUserAssociation(caller: User, id: Int): Association? = transaction(db) {
		User.findById(id)?.getIfAllowed(caller)?.load(User::association)
	}?.association

	fun getAllCount(caller: User, searchParam: SearchParam): Long? {
		if (caller.scope == EUserScope.User) {
			return null
		}
		val param = searchParam.copy(filter = searchParam.filter.toMutableList())
		if (caller.scope not EUserScope.Root) {
			param.filter.add(Filter(Associations.id, caller.association.id.value.toString(), FilterMode.EQUAL))
		}
		return transaction(db) {
			Users.innerJoin(Associations).selectAll().applyParam(param, false).count()
		}
	}

	suspend fun deleteUser(caller: User, user: User): Result<Unit> {
		if(!authorizeDelete(caller, user)) {
			return Result.failure(NotAllowedException())
		}
		user.profilePicture?.let { storageService.delete(it) }
		transaction(db) {
			EventImage.find { EventImages.owner eq user.id }.toList()
		}.forEach {
			storageService.delete(it.path)
		}
		transaction(db) {
			UserJourney.find { UsersJourneys.user eq user.id }.toList()
		}.forEach {
			storageService.delete(it.journey)
		}
		transaction(db) { user.delete() }
		return Result.success(Unit)
	}
}
