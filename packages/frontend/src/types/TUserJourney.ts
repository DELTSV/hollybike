/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
export interface TUserJourney {
	id: number,
	file: string,
	avg_speed?: number,
	total_elevation_loss?: number,
	total_elevation_gain?: number,
	total_distance?: number,
	min_elevation?: number,
	max_elevation?: number,
	total_time?: number,
	max_speed?: number
}
