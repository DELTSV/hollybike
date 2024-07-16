/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.base

import io.ktor.client.request.*
import io.ktor.http.*

fun HttpMessageBuilder.auth(user: Pair<Int, String>) {
	header("Authorization", "Bearer ${IntegrationSpec.tokenStore[user]}")
}