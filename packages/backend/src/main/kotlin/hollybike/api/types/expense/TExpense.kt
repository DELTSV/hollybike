package hollybike.api.types.expense

import hollybike.api.repository.Expense
import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TExpense(
	val id: Int,
	val name: String,
	val description: String? = null,
	val date: Instant,
	val amount: Int
) {
	constructor(entity: Expense): this(
		entity.id.value,
		entity.name,
		entity.description,
		entity.date,
		entity.amount
	)
}