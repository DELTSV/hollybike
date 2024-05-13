package hollybike.api.services

import aws.smithy.kotlin.runtime.text.encoding.encodeBase64String
import de.nycode.bcrypt.hash
import de.nycode.bcrypt.verify
import hollybike.api.exceptions.*
import hollybike.api.repository.Association
import hollybike.api.repository.Associations
import hollybike.api.repository.User
import hollybike.api.repository.Users
import hollybike.api.services.storage.StorageService
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import hollybike.api.types.user.TUserUpdateSelf
import hollybike.api.utils.search.Filter
import hollybike.api.utils.search.FilterMode
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import io.ktor.util.*
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.exceptions.ExposedSQLException
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.andWhere
import org.jetbrains.exposed.sql.selectAll
import org.jetbrains.exposed.sql.transactions.transaction
import org.postgresql.util.PSQLException
import java.sql.BatchUpdateException


class UserService(
	private val db: Database,
	private val storageService: StorageService,
) {
	private fun checkUserScope(caller: User, user: User?): User? {
		if ((caller.scope == EUserScope.User && caller.id != user?.id) || (caller.association != user?.association && caller.scope != EUserScope.Root)) {
			return null
		}
		return user
	}

	fun getUser(caller: User, id: Int): User? = transaction(db) {
		val user = User.find { Users.id eq id }.singleOrNull()
		checkUserScope(caller, user)
	}

	suspend fun uploadUserProfilePicture(
		caller: User,
		user: User,
		image: ByteArray,
		imageContentType: String,
	): Boolean {
		if (checkUserScope(caller, user) == null) {
			return false
		}

		val path = "u/${user.id}/p"
		storageService.store(image, path, imageContentType)
		transaction(db) { user.profilePicture = path }
		return true
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
		val user = User.find { Users.email eq email }.singleOrNull()
		checkUserScope(caller, user)
	}

	fun getUserByUsername(caller: User, username: String): User? = transaction(db) {
		val user = User.find { Users.username eq username }.singleOrNull()
		checkUserScope(caller, user)
	}

	fun updateMe(user: User, update: TUserUpdateSelf): Result<User> = transaction(db) {
		user.apply {
			update.newPassword?.let {
				if ((update.newPasswordAgain == null || update.oldPassword == null)) {
					return@transaction Result.failure(BadRequestException())
				}
				if (update.newPassword != update.newPasswordAgain) {
					return@transaction Result.failure(UserDifferentNewPassword())
				}
				if (!verify(update.oldPassword, user.password.decodeBase64Bytes())) {
					return@transaction Result.failure(UserWrongPassword())
				}
				user.password = hash(it).encodeBase64()
			}
			update.username?.let { user.username = it }
		}
		return@transaction Result.success(user)
	}

	fun getAll(caller: User, searchParam: SearchParam): List<User>? {
		if (caller.scope == EUserScope.User) {
			return null
		}
		if (caller.scope not EUserScope.Root) {
			searchParam.filter.add(Filter(Associations.id, caller.id.value.toString(), FilterMode.EQUAL))
		}
		return transaction(db) {
			User.wrapRows(Users.innerJoin(Associations).selectAll().applyParam(searchParam).andWhere {
				if (caller.scope not EUserScope.Root) {
					Associations.id eq caller.association.id
				} else {
					Associations.id neq null
				}
			}).with(User::association).toList()
		}
	}

	fun getUserAssociation(id: Int): Association? = transaction(db) {
		User.findById(id)?.load(User::association)
	}?.association

	fun getAllCount(caller: User, searchParam: SearchParam): Long? {
		if (caller.scope == EUserScope.User) {
			return null
		}

		return transaction(db) {
			User.wrapRows(Users.innerJoin(Associations).selectAll().applyParam(searchParam).andWhere {
				if (caller.scope not EUserScope.Root) {
					Associations.id eq caller.association.id
				} else {
					Associations.id neq null
				}
			}).with(User::association).count()
		}
	}
}
