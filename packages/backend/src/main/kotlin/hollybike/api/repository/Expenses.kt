package hollybike.api.repository

import hollybike.api.utils.search.Mapper
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object Expenses : IntIdTable("expenses", "id_expense") {
	val name = varchar("name", 2_048)
	val description = text("description").nullable().default(null)
	val date = timestamp("date").default(Clock.System.now())
	val amount = integer("amount")
	val event = reference("event", Events)
}

class Expense(id: EntityID<Int>) : IntEntity(id) {
	var name by Expenses.name
	var description by Expenses.description
	var date by Expenses.date
	var amount by Expenses.amount
	var event by Event referencedOn Expenses.event

	companion object: IntEntityClass<Expense>(Expenses)
}

val expenseMapper: Mapper = mapOf(
	"expense_name" to Expenses.name,
	"expense_date" to Expenses.date,
	"amount" to Expenses.amount
)