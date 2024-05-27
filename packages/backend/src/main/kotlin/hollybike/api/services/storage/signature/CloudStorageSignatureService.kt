package hollybike.api.services.storage.signature

import hollybike.api.ConfSecurity
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import kotlinx.datetime.toJavaInstant
import software.amazon.awssdk.services.cloudfront.CloudFrontUtilities
import software.amazon.awssdk.services.cloudfront.model.CannedSignerRequest
import java.io.File
import kotlin.time.Duration.Companion.days

class CloudStorageSignatureService(
	private val conf: ConfSecurity,
): StorageSignatureService {
	private fun getSignedPath(path: String): String {
		val cloudFrontUtilities = CloudFrontUtilities.create()
		val expirationDate: Instant = Clock.System.now() + 7.days
		val resourceUrl = "${conf.domain}/storage/$path"
		val keyPairId = "K1UA3WV15I7JSD"
		val cannedRequest = CannedSignerRequest.builder()
			.resourceUrl(resourceUrl)
			.privateKey(File("/path/to/private_key.pem").toPath())
			.keyPairId(keyPairId)
			.expirationDate(expirationDate.toJavaInstant())
			.build()
		val signedUrl = cloudFrontUtilities.getSignedUrlWithCannedPolicy(cannedRequest)
		val url = signedUrl.url()
		println(url)

		return url
	}

	override val signer = { path: String -> getSignedPath(path) }
}