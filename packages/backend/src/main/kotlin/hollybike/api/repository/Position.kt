package hollybike.api.repository

import hollybike.api.database.now
import hollybike.api.repository.Invitations.defaultExpression
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object Positions: IntIdTable("positions", "id_position") {
	val latitude = double("latitude")
	val longitude = double("longitude")
	val altitude = double("altitude").nullable()
	val placeType = varchar("place_type", 255)
	val placeName = varchar("place_name", 255).nullable()
	val cityName = varchar("city_name", 255).nullable()
	val countryName = varchar("country_name", 255).nullable()
	val countyName = varchar("county_name", 255).nullable()
	val stateName = varchar("state_name", 255).nullable()
	val createDateTime = timestamp("create_date_time").defaultExpression(now())
}

class Position(id: EntityID<Int>) : IntEntity(id) {
	var latitude by Positions.latitude
	var longitude by Positions.longitude
	var altitude by Positions.altitude
	var placeType by Positions.placeType
	var placeName by Positions.placeName
	var cityName by Positions.cityName
	var countryName by Positions.countryName
	var countyName by Positions.countyName
	var stateName by Positions.stateName
	var createDateTime by Positions.createDateTime

	companion object: IntEntityClass<Position>(Positions);
}