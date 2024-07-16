/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.utils

import io.ktor.http.*

val ContentType.Application.GeoJson: ContentType
	get() = ContentType("application", "geo+json")