package hollybike.api.services

import de.nycode.bcrypt.hash
import de.nycode.bcrypt.verify
import hollybike.api.exceptions.BadRequestException
import hollybike.api.exceptions.UserDifferentNewPassword
import hollybike.api.exceptions.UserWrongPassword
import hollybike.api.repository.Association
import hollybike.api.repository.Associations
import hollybike.api.repository.User
import hollybike.api.repository.Users
import hollybike.api.services.storage.StorageService
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.TUser
import hollybike.api.types.user.TUserUpdateSelf
import hollybike.api.utils.search.Filter
import hollybike.api.utils.search.FilterMode
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import io.ktor.util.*
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.JoinType
import org.jetbrains.exposed.sql.count
import org.jetbrains.exposed.sql.selectAll
import org.jetbrains.exposed.sql.transactions.transaction


class UserService(
	private val db: Database,
	private val storageService: StorageService,
) {
	fun getUser(caller: User?, id: Int): User? = transaction(db) {
		val user = User.find { Users.id eq id }.singleOrNull()
		if (caller != null && caller.association != user?.association && caller.scope == EUserScope.User) {
			null
		} else {
			user
		}
	}

	suspend fun uploadUserProfilePicture(
		caller: User,
		user: User,
		image: ByteArray,
		imageContentType: String,
	): Boolean {
		if(caller.id != user.id && caller.scope == EUserScope.User) {
			return false
		}
		val path = "u/${user.id}/p"
		storageService.store(image, path, imageContentType)
		transaction(db) { user.profilePicture = path }
		return true
	}

	fun getUserByEmail(caller: User?, email: String): User? = transaction(this.db) {
		val user = User.find { Users.email eq email }.singleOrNull()
		if (caller != null && caller.association != user?.association && caller.scope == EUserScope.User) {
			null
		} else {
			user
		}
	}

	fun getUserByUsername(caller: User?, username: String): User? = transaction(db) {
		val user = User.find { Users.username eq username }.singleOrNull()
		if (caller != null && caller.association != user?.association && caller.scope == EUserScope.User) {
			null
		} else {
			user
		}
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
		if(caller.scope == EUserScope.User) {
			return null
		}
		if(caller.scope not EUserScope.Root) {
			searchParam.filter.add(Filter(Associations.id, caller.id.value.toString(), FilterMode.EQUAL))
		}
		return transaction(db) {
			User.wrapRows(Users.innerJoin(Associations).selectAll().applyParam(searchParam))
				.with(User::association)
				.toList()
		}
	}

	fun getAllCount(caller: User, searchParam: SearchParam): Long? {
		if(caller.scope == EUserScope.User) {
			return null
		}
		if(caller.scope not EUserScope.Root) {
			searchParam.filter.add(Filter(Associations.id, caller.id.value.toString(), FilterMode.EQUAL))
		}
		return transaction(db) {
			Users.innerJoin(Associations).selectAll().count()
		}
	}
}
