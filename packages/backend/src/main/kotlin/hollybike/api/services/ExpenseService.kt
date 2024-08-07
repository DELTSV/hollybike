/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services

import hollybike.api.exceptions.BadAmountException
import hollybike.api.exceptions.CannotCreateExpenseException
import hollybike.api.exceptions.EventNotFoundException
import hollybike.api.exceptions.NotAllowedException
import hollybike.api.repository.*
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.participation.EEventRole
import hollybike.api.types.expense.TNewExpense
import hollybike.api.types.expense.TUpdateExpense
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.search.Filter
import hollybike.api.utils.search.FilterMode
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import io.ktor.http.*
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.SortOrder
import org.jetbrains.exposed.sql.innerJoin
import org.jetbrains.exposed.sql.selectAll
import org.jetbrains.exposed.sql.transactions.transaction
import java.util.*

class ExpenseService(
	private val db: Database,
	private val eventService: EventService,
	private val storageService: StorageService
) {
	private fun authorizeGetOrUpdateOrDelete(caller: User, expense: Expense): Boolean = when (caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> expense.event.association.id == caller.association.id
		EUserScope.User -> expense.event.participants.any { it.user.id == caller.id && it.role == EEventRole.Organizer }
	}

	private infix fun Expense?.getIfAllowed(caller: User) =
		this?.let { if (authorizeGetOrUpdateOrDelete(caller, it)) it else null }

	private fun authorizeCreate(caller: User, event: Event): Boolean = when (caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> event.association.id == caller.association.id
		EUserScope.User -> event.participants.any { it.user.id == caller.id && it.role == EEventRole.Organizer }
	}

	private fun authorizeParticipant(callerParticipation: EventParticipation, caller: User, event: Event): Boolean = when {
		callerParticipation.role == EEventRole.Organizer -> true
		caller.scope == EUserScope.Admin && event.association.id == caller.association.id -> true
		caller.scope == EUserScope.Root -> true
		else -> false
	}

	fun authorizeBudget(caller: User, event: Event): Boolean = when (caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> event.association.id == caller.association.id
		EUserScope.User -> event.participants.any { it.user.id == caller.id && it.role == EEventRole.Organizer }
	}

	fun getExpense(caller: User, id: Int): Expense? = transaction(db) {
		Expense.findById(id)?.load(Expense::event) getIfAllowed caller
	}

	fun getEventExpense(callerParticipation: EventParticipation, caller: User, event: Event): List<Expense>? = transaction(db) {
		if (authorizeParticipant(callerParticipation, caller, event)) {
			Expense.find { Expenses.event eq event.id }.orderBy(Expenses.date to SortOrder.ASC).toList()
		} else {
			null
		}
	}

	fun getAll(caller: User, searchParam: SearchParam): List<Expense> {
		val param = if (caller.scope == EUserScope.Admin) {
			searchParam.copy(
				filter = searchParam.filter.toMutableList().apply {
					add(Filter(Events.association, caller.association.id.value.toString(), FilterMode.EQUAL))
				}
			)
		} else {
			searchParam
		}
		return transaction(db) {
			Expense.wrapRows(
				Expenses
					.innerJoin(Events, { event }, { Events.id })
					.selectAll()
					.applyParam(param)
			).with(Expense::event).toList()
		}
	}

	fun getAllCount(caller: User, searchParam: SearchParam): Long {
		val param = if (caller.scope == EUserScope.Admin) {
			searchParam.copy(
				filter = searchParam.filter.toMutableList().apply {
					add(Filter(Events.association, caller.association.id.value.toString(), FilterMode.EQUAL))
				}
			)
		} else {
			searchParam
		}
		return transaction(db) {
			Expenses
				.innerJoin(Events, { event }, { Events.id })
				.selectAll()
				.applyParam(param, false)
				.count()
		}
	}

	fun createExpense(caller: User, newExpense: TNewExpense): Result<Expense> {
		val event = eventService.getEvent(caller, newExpense.event) ?: run {
			return Result.failure(EventNotFoundException())
		}
		if (!authorizeCreate(caller, event)) {
			return Result.failure(CannotCreateExpenseException())
		}
		if (newExpense.amount < 1) {
			return Result.failure(BadAmountException())
		}
		val expense = transaction(db) {
			Expense.new {
				name = newExpense.name
				description = newExpense.description
				date = newExpense.date
				amount = newExpense.amount
				this.event = event
			}
		}
		return Result.success(expense)
	}

	fun updateExpense(caller: User, expense: Expense, update: TUpdateExpense): Result<Expense> {
		if (!authorizeGetOrUpdateOrDelete(caller, expense)) {
			return Result.failure(NotAllowedException())
		}
		transaction(db) {
			update.name?.let { expense.name = it }
			update.description?.let { expense.description = it }
			update.date?.let { expense.date = it }
			update.amount?.let { expense.amount = it }
		}
		return Result.success(expense)
	}

	suspend fun deleteExpense(caller: User, expense: Expense): Result<Unit> {
		if(!authorizeGetOrUpdateOrDelete(caller, expense)) {
			return Result.failure(NotAllowedException())
		}
		transaction(db) { expense.delete() }
		expense.proof?.let {
			storageService.delete(it)
		}
		return Result.success(Unit)
	}

	suspend fun uploadProof(caller: User, expense: Expense, data: ByteArray, contentType: ContentType): Result<Expense> {
		if(!authorizeGetOrUpdateOrDelete(caller, expense)) {
			return Result.failure(NotAllowedException())
		}

		try {
			expense.proof?.let { storageService.delete(it) }
		} catch (e: Exception) {
			e.printStackTrace()
		}

		val uuid = UUID.randomUUID().toString()
		val path = "e/${expense.event.id}/e/${expense.id}/p-$uuid"
		storageService.store(data, path, contentType.contentType)

		transaction(db) {
			expense.proof = path
		}
		return Result.success(expense)
	}
}