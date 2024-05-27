package hollybike.api.services.storage.signature

import hollybike.api.ConfSecurity
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import kotlinx.datetime.toJavaInstant
import software.amazon.awssdk.services.cloudfront.CloudFrontUtilities
import software.amazon.awssdk.services.cloudfront.model.CannedSignerRequest
import java.nio.file.Path
import kotlin.time.Duration.Companion.hours

class CloudFrontStorageSignatureService(
	private val conf: ConfSecurity,
): StorageSignatureService {
	override val mode = StorageSignatureMode.CLOUDFRONT

	private val cloudFrontUtilities: CloudFrontUtilities = CloudFrontUtilities.create()
	private var privateKeyPath: Path = kotlin.io.path.createTempFile(
		prefix = "storage-signature",
		suffix = ".pem"
	)

	init {
		if (conf.cfPrivateKeySecret == null || conf.cfKeyPairId == null) {
			throw IllegalArgumentException("CloudFront configuration is missing")
		}

		privateKeyPath.toFile().writeText(conf.cfPrivateKeySecret)
	}

	private fun getSignedPath(path: String): String {
		val expirationDate: Instant = Clock.System.now() + 1.hours
		val resourceUrl = "${conf.domain}/storage/$path"
		val keyPairId = conf.cfKeyPairId!!
		val cannedRequest = CannedSignerRequest.builder()
			.resourceUrl(resourceUrl)
			.privateKey(privateKeyPath)
			.keyPairId(keyPairId)
			.expirationDate(expirationDate.toJavaInstant())
			.build()

		val signedUrl = cloudFrontUtilities.getSignedUrlWithCannedPolicy(cannedRequest)

		return signedUrl.url()
	}

	override val sign = { path: String -> getSignedPath(path) }
}