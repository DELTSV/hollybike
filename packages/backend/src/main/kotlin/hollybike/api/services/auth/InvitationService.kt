/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services.auth

import hollybike.api.exceptions.AssociationNotFound
import hollybike.api.exceptions.InvitationAlreadyExist
import hollybike.api.exceptions.InvitationNotFoundException
import hollybike.api.exceptions.NotAllowedException
import hollybike.api.repository.*
import hollybike.api.repository.Invitations.creator
import hollybike.api.types.invitation.EInvitationStatus
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.SqlExpressionBuilder.neq
import org.jetbrains.exposed.sql.transactions.transaction

class InvitationService(
	private val db: Database
) {
	private fun getInvitation(
		caller: User,
		role: EUserScope,
		association: Association,
		maxUse: Int? = null,
		expiration: Instant? = null
	): Result<Invitation> {
		if (caller.scope == EUserScope.User) {
			return Result.failure(NotAllowedException())
		}
		if (caller.scope == EUserScope.Root && caller.association.id != caller.association.id) {
			return Result.failure(NotAllowedException())
		}
		var condition =
			(Invitations.role eq role.value) and (Invitations.status neq EInvitationStatus.Disabled.value) and (Invitations.association eq association.id.value)
		maxUse?.let { condition = condition and (Invitations.maxUses eq it) }
		expiration?.let { condition = condition and (Invitations.expiration eq it) }
		transaction(db) { Invitation.find(condition).singleOrNull() }?.let {
			return Result.success(it)
		} ?: run {
			return Result.failure(InvitationNotFoundException())
		}
	}

	fun getValidInvitation(id: Int) = transaction(db) {
		Invitation.find {
			(Invitations.id eq id) and
				(Invitations.status eq EInvitationStatus.Enabled.value) and
				(Invitations.maxUses.isNull() or (Invitations.uses less Invitations.maxUses)) and
				(Invitations.expiration.isNull() or (Invitations.expiration greater Clock.System.now()))
		}.singleOrNull()?.load(Invitation::association, Invitation::creator) ?: run {
			Invitation.findById(id)?.status = EInvitationStatus.Disabled
			return@transaction null
		}
	}

	fun createInvitation(
		caller: User,
		label: String?,
		role: EUserScope,
		association: Int,
		maxUses: Int? = null,
		expiration: Instant? = null
	): Result<Invitation> {
		if (caller.scope == EUserScope.User || caller.scope not role || (caller.association.id.value != association && caller.scope != EUserScope.Root)) {
			return Result.failure(NotAllowedException())
		}
		val assoc = transaction(db) { Association.findById(association) } ?: run {
			return Result.failure(AssociationNotFound())
		}
		if (getInvitation(caller, role, assoc, maxUses, expiration).isSuccess) {
			return Result.failure(InvitationAlreadyExist())
		}
		val invitation = transaction(db) {
			Invitation.new {
				this.label = label
				this.creator = caller
				this.role = role
				this.association = assoc
				this.maxUses = maxUses
				this.expiration = expiration
				this.status = EInvitationStatus.Enabled
			}
		}
		return Result.success(invitation)
	}

	fun disableInvitation(caller: User, id: Int): Result<Invitation> {
		if (caller.scope == EUserScope.User) {
			return Result.failure(NotAllowedException())
		}
		transaction(db) {
			Invitation.find(
				Invitations.id eq id
			).with(Invitation::association).singleOrNull()?.apply {
				status = EInvitationStatus.Disabled
			}
		}?.let {
			if (it.association.id != caller.association.id && caller.scope != EUserScope.Root) {
				return Result.failure(NotAllowedException())
			}

			return Result.success(it)
		} ?: return Result.failure(InvitationNotFoundException())
	}

	fun getAll(caller: User, searchParam: SearchParam): Result<List<Invitation>> {
		if (caller.scope != EUserScope.Root) {
			return Result.failure(NotAllowedException())
		}
		val invitations = transaction(db) {
			Invitation.wrapRows(
				Invitations
					.innerJoin(Associations, { association }, { Associations.id })
					.innerJoin(Users, { creator }, { Users.id })
					.selectAll()
					.applyParam(searchParam)
			).with(Invitation::association).toList()
		}
		return Result.success(invitations)
	}

	fun getAllCount(caller: User, searchParam: SearchParam): Long? {
		if (caller.scope != EUserScope.Root) {
			return null
		}
		return transaction(db) {
			Invitations
				.innerJoin(Associations, { this.association }, { Associations.id })
				.innerJoin(Users, { creator }, { Users.id })
				.selectAll()
				.applyParam(searchParam, pagination = false)
				.count()
		}
	}


	fun getAllByAssociation(
		caller: User,
		association: Association,
		searchParam: SearchParam
	): Result<List<Invitation>> {
		if ((caller.scope == EUserScope.Admin && association.id != caller.association.id)) {
			return Result.failure(NotAllowedException())
		}
		val invitations = transaction(db) {
			Invitation.wrapRows(
				Invitations
					.innerJoin(Associations, { this.association }, { Associations.id })
					.innerJoin(Users, { creator }, { Users.id })
					.selectAll()
					.applyParam(searchParam)
					.andWhere {
						Associations.id eq association.id
					})
				.with(Invitation::association)
				.toList()
		}
		return Result.success(invitations)
	}

	fun getAllByAssociationCount(caller: User, association: Association, searchParam: SearchParam): Long? {
		if ((caller.scope == EUserScope.Admin && association.id != caller.association.id)) {
			return null
		}
		return transaction(db) {
			Invitations
				.innerJoin(Associations, { this.association }, { Associations.id })
				.innerJoin(Users, { creator }, { Users.id })
				.selectAll()
				.applyParam(searchParam)
				.andWhere { Associations.id eq association.id }
				.count()
		}
	}
}