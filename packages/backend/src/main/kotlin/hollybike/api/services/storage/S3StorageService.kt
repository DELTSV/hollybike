package hollybike.api.services.storage

import aws.sdk.kotlin.services.s3.S3Client
import aws.sdk.kotlin.services.s3.model.GetObjectRequest
import aws.sdk.kotlin.services.s3.model.HeadBucketRequest
import aws.sdk.kotlin.services.s3.model.PutObjectRequest
import aws.smithy.kotlin.runtime.content.ByteStream
import aws.smithy.kotlin.runtime.content.toByteArray
import aws.smithy.kotlin.runtime.net.url.Url
import kotlinx.coroutines.runBlocking

class S3StorageService(
	private val isDev: Boolean,
	private val bucketName: String?,
	private val bucketRegion: String,
) : StorageService {
	override val mode = StorageMode.S3

	private val client = S3Client {
		endpointUrl = if (isDev) Url.parse("http://localhost:9000") else null
		region = bucketRegion
		forcePathStyle = isDev
	}

	init {
		if (bucketName == null) throw IllegalArgumentException("Bucket name is required for S3 storage")

		runBlocking {
			if (!client.bucketExists(bucketName)) {
				throw Exception("Cannot reach bucket $bucketName")
			}
		}
	}

	private suspend fun S3Client.bucketExists(s3bucket: String) =
		try {
			headBucket(HeadBucketRequest { bucket = s3bucket })
			true
		} catch (e: Exception) {
			e.printStackTrace()
			false
		}

	override suspend fun store(data: ByteArray, path: String, dataContentType: String) {
		client.putObject(PutObjectRequest {
			bucket = bucketName
			key = "storage/$path"
			body = ByteStream.fromBytes(data)
			contentType = dataContentType
		})
	}

	override suspend fun retrieve(path: String): ByteArray? {
		return try {
			client.getObject(GetObjectRequest {
				bucket = bucketName
				key = "storage/$path"
			}, block = {
				it.body?.toByteArray()
			})
		} catch (e: Exception) {
			null
		}
	}
}