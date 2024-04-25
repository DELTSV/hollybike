package hollybike.api.services

import aws.sdk.kotlin.services.s3.S3Client
import aws.sdk.kotlin.services.s3.model.HeadBucketRequest
import aws.sdk.kotlin.services.s3.model.PutObjectRequest
import aws.smithy.kotlin.runtime.content.ByteStream
import hollybike.api.Conf
import hollybike.api.repository.User
import hollybike.api.repository.Users
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction

class UserService(
	private val db: Database,
	private val config: Conf,
) {
	fun getUser(
		caller: User?,
		id: Int,
	): User? =
		transaction(db) {
			val user = User.find { Users.id eq id }.singleOrNull()
			if (caller != null && caller.association != user?.association && caller.scope != 2) {
				null
			} else {
				user
			}
		}

	fun getUserByEmail(
		caller: User?,
		email: String,
	): User? =
		transaction(this.db) {
			val user = User.find { Users.email eq email }.singleOrNull()
			if (caller != null && caller.association != user?.association && caller.scope != 2) {
				null
			} else {
				user
			}
		}

	fun getUserByUsername(
		caller: User?,
		username: String,
	): User? =
		transaction(db) {
			val user = User.find { Users.username eq username }.singleOrNull()
			if (caller != null && caller.association != user?.association && caller.scope != 2) {
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
}
