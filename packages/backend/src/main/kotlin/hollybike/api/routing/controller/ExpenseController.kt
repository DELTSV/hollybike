package hollybike.api.routing.controller

import hollybike.api.exceptions.BadAmountException
import hollybike.api.exceptions.CannotCreateExpenseException
import hollybike.api.exceptions.EventNotFoundException
import hollybike.api.exceptions.NotAllowedException
import hollybike.api.plugins.user
import hollybike.api.repository.eventMapper
import hollybike.api.repository.expenseMapper
import hollybike.api.routing.resources.Expenses
import hollybike.api.services.ExpenseService
import hollybike.api.types.expense.TExpense
import hollybike.api.types.expense.TNewExpense
import hollybike.api.types.expense.TUpdateExpense
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.get
import hollybike.api.utils.search.getMapperData
import hollybike.api.utils.search.getSearchParam
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.resources.patch
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*

class ExpenseController(
	application: Application,
	private val expenseService: ExpenseService
) {
	init {
		application.routing {
			authenticate {
				getAllExpenses()
				getMetadata()
				getExpense()
				createExpense()
				updateExpense()
			}
		}
	}

	private fun Route.getAllExpenses() {
		get<Expenses>(EUserScope.Admin) {
			val param = call.request.queryParameters.getSearchParam(expenseMapper + eventMapper)
			val count = expenseService.getAllCount(call.user, param)
			val data = expenseService.getAll(call.user, param).map { TExpense(it) }
			call.respond(TLists(data, param, count))
		}
	}

	private fun Route.getMetadata() {
		get<Expenses.Metadata> {
			call.respond((expenseMapper + eventMapper).getMapperData())
		}
	}

	private fun Route.getExpense() {
		get<Expenses.Id> {
			expenseService.getExpense(call.user, it.id)?.let { e ->
				call.respond(TExpense(e))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "La dépense n'existe pas")
			}
		}
	}

	private fun Route.createExpense() {
		post<Expenses> {
			val newExpense = call.receive<TNewExpense>()
			expenseService.createExpense(call.user, newExpense).onSuccess {
				call.respond(HttpStatusCode.Created, TExpense(it))
			}.onFailure {
				when(it) {
					is EventNotFoundException -> call.respond(HttpStatusCode.NotFound, "L'évènement n'existe pas")
					is CannotCreateExpenseException -> call.respond(HttpStatusCode.Forbidden)
					is BadAmountException -> call.respond(HttpStatusCode.BadRequest, "Le montant doit être supérieur à 0")
				}
			}
		}
	}

	private fun Route.updateExpense() {
		patch<Expenses.Id> {
			val updateExpense = call.receive<TUpdateExpense>()
			val expense = expenseService.getExpense(call.user, it.id) ?: run {
				return@patch call.respond(HttpStatusCode.NotFound, "La dépense n'existe pas")
			}
			expenseService.updateExpense(call.user, expense, updateExpense).onSuccess { e ->
				call.respond(HttpStatusCode.OK, TExpense(e))
			}.onFailure {
				when(it) {
					is NotAllowedException -> call.respond(HttpStatusCode.Forbidden)
				}
			}
		}
	}
}