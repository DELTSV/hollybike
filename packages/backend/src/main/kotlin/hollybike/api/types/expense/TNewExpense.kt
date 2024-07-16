/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.expense

import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TNewExpense(
	val name: String,
	val description: String? = null,
	val date: Instant,
	val amount: Int,
	val event: Int
)
