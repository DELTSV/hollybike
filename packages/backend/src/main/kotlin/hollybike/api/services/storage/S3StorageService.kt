/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services.storage

import aws.sdk.kotlin.runtime.auth.credentials.*
import aws.sdk.kotlin.services.s3.S3Client
import aws.sdk.kotlin.services.s3.model.*
import aws.smithy.kotlin.runtime.content.ByteStream
import aws.smithy.kotlin.runtime.content.toByteArray
import aws.smithy.kotlin.runtime.http.HttpException
import aws.smithy.kotlin.runtime.net.url.Url
import hollybike.api.services.storage.signature.StorageSignatureService
import kotlinx.coroutines.runBlocking

class S3StorageService(
	private val url: String?,
	private val bucketName: String,
	private val bucketRegion: String,
	private val username: String? = null,
	private val password: String? = null,
	override val signer : StorageSignatureService
) : StorageService {
	override val mode = StorageMode.S3

	private val client = S3Client {
		endpointUrl = url?.let { Url.parse(url) }
		region = bucketRegion
		forcePathStyle = url != null
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
				if(url != null) {
					throw StorageInitException("Cannot reach bucket `$bucketName` in region `$bucketRegion` on url `$url`, check parameters")
				} else {
					throw StorageInitException("Cannot reach bucket `$bucketName` in region `$bucketRegion`, check parameters")
				}
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

	override suspend fun delete(path: String) {
		client.deleteObject(DeleteObjectRequest {
			bucket = bucketName
			key = "storage/$path"
		})
	}

	override suspend fun batchStore(data: List<Pair<ByteArray, String>>, dataContentType: String) {
		data.forEach {
			store(it.first, it.second, dataContentType)
		}
	}

	override suspend fun batchDelete(paths: List<String>) {
		paths.forEach {
			delete(it)
		}
	}
}