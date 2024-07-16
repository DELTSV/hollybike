/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services

import hollybike.api.repository.*
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.search.*
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.selectAll
import org.jetbrains.exposed.sql.transactions.transaction

class ProfileService(
	private val db: Database
) {
	private fun authorizeGet(caller: User, target: User): Boolean = when(caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> caller.association.id == target.association.id
		EUserScope.User -> caller.association.id == target.association.id
	}

	private infix fun User?.getIfAllowed(caller: User) = this?.let { if(authorizeGet(caller, this)) this else null }

	fun getProfileById(caller: User, id: Int): User? = transaction(db) {
		User.findById(id) getIfAllowed caller
	}

	fun getAllProfile(caller: User, searchParam: SearchParam): List<User> {
		val param = searchParam.copy(filter = searchParam.filter.toMutableList())
		if (caller.scope not EUserScope.Root) {
			param.filter.add(Filter(Associations.id, caller.association.id.value.toString(), FilterMode.EQUAL))
		}
		return transaction(db) {
			User.wrapRows(Users.innerJoin(Associations).selectAll().applyParam(param)).with(User::association).toList()
		}
	}

	fun getAllProfileCount(caller: User, searchParam: SearchParam): Long {
		val param = searchParam.copy(filter = searchParam.filter.toMutableList())
		if (caller.scope not EUserScope.Root) {
			param.filter.add(Filter(Associations.id, caller.association.id.value.toString(), FilterMode.EQUAL))
		}
		return transaction(db) {
			Users.innerJoin(Associations).selectAll().applyParam(param, false).count()
		}
	}
}