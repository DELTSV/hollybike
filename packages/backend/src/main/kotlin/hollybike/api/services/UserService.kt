package hollybike.api.services

import aws.sdk.kotlin.services.s3.S3Client
import aws.sdk.kotlin.services.s3.model.HeadBucketRequest
import aws.sdk.kotlin.services.s3.model.PutObjectRequest
import aws.smithy.kotlin.runtime.content.ByteStream
import de.nycode.bcrypt.hash
import de.nycode.bcrypt.verify
import hollybike.api.Conf
import hollybike.api.exceptions.BadRequestException
import hollybike.api.exceptions.UserDifferentNewPassword
import hollybike.api.exceptions.UserWrongPassword
import hollybike.api.repository.User
import hollybike.api.repository.Users
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.TUserUpdateSelf
import io.ktor.util.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction


class UserService(
	private val db: Database,
	private val config: Conf,
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
		caller: User?,
		image: ByteArray,
		imageContentType: String,
	): Boolean {
		val client = S3Client { region = config.storage.region }

		try {
			if (config.storage.bucketName == null) {
				throw Exception("Bucket name not set")
			}

			println(config.storage.bucketName)

			if (!client.bucketExists(config.storage.bucketName!!)) {
				throw Exception("Bucket does not exist")
			}

			client.putObject(PutObjectRequest {
				bucket = config.storage.bucketName
				key = "storage/u/${caller?.id}/p"
				body = ByteStream.fromBytes(image)
				contentType = imageContentType
			})

		} finally {
			withContext(Dispatchers.IO) {
				client.close()
			}
		}

		return true
	}

	private suspend fun S3Client.bucketExists(s3bucket: String) =
		try {
			headBucket(HeadBucketRequest { bucket = s3bucket })
			true
		} catch (e: Exception) {
			false
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
}
