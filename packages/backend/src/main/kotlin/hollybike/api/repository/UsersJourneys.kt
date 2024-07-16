/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.repository

import hollybike.api.database.now
import hollybike.api.signatureService
import hollybike.api.utils.search.Mapper
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object UsersJourneys : IntIdTable("users_journeys", "id_user_journey") {
	val journey = varchar("journey", 2048)
	val avgSpeed = double("avg_speed").nullable()
	val totalElevationLoss = double("total_elevation_loss").nullable()
	val totalElevationGain = double("total_elevation_gain").nullable()
	val totalDistance = double("total_distance").nullable()
	val minElevation = double("min_elevation").nullable()
	val maxElevation = double("max_elevation").nullable()
	val avgGForce = double("avg_g_force").nullable()
	val maxGForce = double("max_g_force").nullable()
	val totalTime = long("total_time").nullable()
	val maxSpeed = double("max_speed").nullable()
	val createdAt = timestamp("created_at").defaultExpression(now())
	val user = reference("user", Users).nullable().default(null)
}

class UserJourney(id: EntityID<Int>) : IntEntity(id) {
	var journey by UsersJourneys.journey
	val journeySigned by UsersJourneys.journey.transform({ it }, { signatureService.sign(it) })
	var avgSpeed by UsersJourneys.avgSpeed
	var totalElevationLoss by UsersJourneys.totalElevationLoss
	var totalElevationGain by UsersJourneys.totalElevationGain
	var totalDistance by UsersJourneys.totalDistance
	var minElevation by UsersJourneys.minElevation
	var maxElevation by UsersJourneys.maxElevation
	var avgGForce by UsersJourneys.avgGForce
	var maxGForce by UsersJourneys.maxGForce
	var totalTime by UsersJourneys.totalTime
	var maxSpeed by UsersJourneys.maxSpeed
	var createdAt by UsersJourneys.createdAt
	var user by User optionalReferencedOn UsersJourneys.user

	companion object : IntEntityClass<UserJourney>(UsersJourneys)
}

val userJourneyMapper: Mapper = mapOf(
	"created_at" to UsersJourneys.createdAt,
)