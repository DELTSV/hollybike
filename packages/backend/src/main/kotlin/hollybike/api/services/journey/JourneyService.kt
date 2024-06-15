package hollybike.api.services.journey

import hollybike.api.exceptions.AssociationNotFound
import hollybike.api.exceptions.NotAllowedException
import hollybike.api.repository.*
import hollybike.api.services.AssociationService
import hollybike.api.services.storage.StorageService
import hollybike.api.types.journey.TNewJourney
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.search.Filter
import hollybike.api.utils.search.FilterMode
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.innerJoin
import org.jetbrains.exposed.sql.selectAll
import org.jetbrains.exposed.sql.transactions.transaction

class JourneyService(
	private val db: Database,
	private val associationService: AssociationService,
	private val storageService: StorageService
) {

	private fun authorizeGet(caller: User, target: Journey): Boolean = when(caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> caller.association.id == target.association.id
		EUserScope.User -> caller.association.id == target.association.id
	}

	private infix fun Journey?.getIfAllowed(caller: User): Journey? =
		if(this != null && authorizeGet(caller, this)) this else null

	private fun authorizeAdd(caller: User, new: TNewJourney): Boolean = when(caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> new.association == null || caller.association.id.value == new.association
		EUserScope.User -> new.association == null || caller.association.id.value == new.association
	}

	private fun authorizeUpload(caller: User, target: Journey): Boolean = when(caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> caller.association.id == target.association.id
		EUserScope.User -> caller.id == target.creator.id
	}

	private fun authorizeDelete(caller: User, target: Journey): Boolean = when(caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> caller.association.id == target.association.id
		EUserScope.User -> caller.id == target.creator.id
	}

	fun getAll(caller: User, searchParam: SearchParam): List<Journey> {
		val param = searchParam.copy(filter = searchParam.filter.toMutableList())
		if(caller.scope not EUserScope.Root) {
			param.filter.add(Filter(Associations.id, caller.association.id.value.toString(), FilterMode.EQUAL))
		}
		return transaction(db) {
			Journey.wrapRows(Journeys
				.innerJoin(Associations, { Journeys.association }, { Associations.id })
				.innerJoin(Users, { Journeys.creator }, { Users.id })
				.selectAll()
				.applyParam(param)
			).with(Journey::association, Journey::creator).toList()
		}
	}

	fun getAllCount(caller: User, searchParam: SearchParam): Long {
		val param = searchParam.copy(filter = searchParam.filter.toMutableList())
		if(caller.scope not EUserScope.Root) {
			param.filter.add(Filter(Associations.id, caller.association.id.value.toString(), FilterMode.EQUAL))
		}
		return transaction(db) {
			Journey.wrapRows(Journeys
				.innerJoin(Associations, { Journeys.association }, { Associations.id })
				.innerJoin(Users, { Journeys.creator }, { Users.id })
				.selectAll()
				.applyParam(param, false)
			).count()
		}
	}

	fun getById(caller: User, id: Int): Journey? = transaction(db) {
		Journey.findById(id)?.load(Journey::creator, Journey::association) getIfAllowed caller
	}

	fun createJourney(caller: User, new: TNewJourney): Result<Journey> {
		if(!authorizeAdd(caller, new)) {
			return Result.failure(NotAllowedException())
		}

		val association = new.association?.let {
			associationService.getById(caller, it) ?: run {
				return Result.failure(AssociationNotFound(""))
			}
		} ?: caller.association

		val journey = transaction(db) {
			Journey.new {
				this.name = new.name
				this.association = association
				this.creator = caller
			}
		}

		return Result.success(journey)
	}

	suspend fun uploadFile(
		caller: User,
		journey: Journey,
		file: ByteArray,
		fileContentType: String,
	): Result<String> {
		if(!authorizeUpload(caller, journey)) {
			return Result.failure(NotAllowedException())
		}

		val path = "j/${journey.id}/f"

		storageService.store(file, path, fileContentType)
		transaction(db) { journey.file = path }
		return Result.success(path)
	}

	suspend fun deleteJourney(caller: User, target: Journey): Boolean {
		if(!authorizeDelete(caller, target)) {
			return false
		}
		target.file?.let { storageService.delete(it) }
		transaction(db) { target.delete() }
		return true
	}
}