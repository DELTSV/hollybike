package hollybike.api.types.expense

import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TUpdateExpense(
	val name: String? = null,
	val description: String? = null,
	val amount: Int? = null,
	val date: Instant? = null
)
