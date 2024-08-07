/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
export interface TPosition {
	latitude: number,
	longitude: number,
	altitude?: number,
	place_name?: string,
	place_type?: string,
	city_name?: string,
	country_name?: string,
	county_name?: string,
	state_name?: string
}
