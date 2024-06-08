package hollybike.api.utils

import io.ktor.http.*

val ContentType.Application.GeoJson: ContentType
	get() = ContentType("application", "geo+json")