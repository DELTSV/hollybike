package hollybike.api.services.storage

import aws.sdk.kotlin.runtime.auth.credentials.*
import aws.sdk.kotlin.services.s3.S3Client
import aws.sdk.kotlin.services.s3.model.GetObjectRequest
import aws.sdk.kotlin.services.s3.model.HeadBucketRequest
import aws.sdk.kotlin.services.s3.model.NotFound
import aws.sdk.kotlin.services.s3.model.PutObjectRequest
import aws.smithy.kotlin.runtime.auth.awscredentials.CredentialsProvider
import aws.smithy.kotlin.runtime.auth.awscredentials.CredentialsProviderChain
import aws.smithy.kotlin.runtime.content.ByteStream
import aws.smithy.kotlin.runtime.content.toByteArray
import aws.smithy.kotlin.runtime.http.HttpException
import aws.smithy.kotlin.runtime.net.url.Url
import io.ktor.server.auth.*
import kotlinx.coroutines.runBlocking
import software.amazon.awssdk.services.s3.internal.s3express.DefaultS3ExpressSessionCredentials

class S3StorageService(
	private val url: String,
	private val bucketName: String,
	private val bucketRegion: String,
	private val isDev: Boolean,
	private val username: String? = null,
	private val password: String? = null
) : StorageService {
	override val mode = StorageMode.S3

	private val client = S3Client {
		endpointUrl = Url.parse(url)
		region = bucketRegion
		forcePathStyle = isDev
		if(username != null || password != null) {
			credentialsProvider = StaticCredentialsProvider {
				this.accessKeyId = username
				this.secretAccessKey = password
			}
		}
	}

	init {
		runBlocking {
			if (!client.bucketExists(bucketName)) {
				throw Exception("Cannot reach bucket $bucketName, check your IAM permissions")
			}
		}
	}

	private suspend fun S3Client.bucketExists(s3bucket: String) =
		try {
			headBucket(HeadBucketRequest { bucket = s3bucket })
			true
		} catch (e: NotFound) {
			System.err.println("Cannot find S3 bucket $bucketName")
			false
		} catch (e: HttpException) {
			System.err.println("Cannot connect to S3 with url $url")
			false
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