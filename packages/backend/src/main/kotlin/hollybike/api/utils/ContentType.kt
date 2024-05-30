package hollybike.api.utils

import io.ktor.http.*
import io.ktor.http.content.*

fun checkContentType(image: PartData.FileItem): Result<ContentType> {
	val contentType = image.contentType ?: run {
		return Result.failure(Exception("Type de contenu de l'image manquant"))
	}

	if (contentType != ContentType.Image.JPEG && contentType != ContentType.Image.PNG) {
		return Result.failure(Exception("Image invalide (JPEG et PNG seulement)"))
	}

	return Result.success(contentType)
}