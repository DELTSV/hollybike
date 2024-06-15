package hollybike.api.repository

import hollybike.api.repository.User.Companion.transform
import hollybike.api.signatureService
import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.utils.search.Mapper
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable

object Associations : IntIdTable("associations", "id_association") {
	val name = varchar("name", 1_000)
	val status = integer("status").default(1)
	val picture = varchar("picture", 2_048).nullable().default(null)
	val updateDefaultUser = bool("update_default_user").default(false)
	val updateAssociation = bool("update_association").default(false)
	val createInvitation = bool("create_invitation").default(false)
}

class Association(id: EntityID<Int>) : IntEntity(id) {
	companion object : IntEntityClass<Association>(Associations)

	var name by Associations.name
	var status by Associations.status.transform({ it.value }, { EAssociationsStatus[it] })
	var picture by Associations.picture
	val signedPicture by Associations.picture.transform({ it }, { it?.let { signatureService.sign(it) } })
	var updateDefaultUser by Associations.updateDefaultUser
	var updateAssociation by Associations.updateAssociation
	var createInvitation by Associations.createInvitation
}

val associationMapper: Mapper = mapOf(
	"id_association" to Associations.id,
	"name" to Associations.name,
	"status" to Associations.status
)