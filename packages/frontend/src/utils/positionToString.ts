/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { TPosition } from "../types/TPosition.ts";

export function positionToString(p?: TPosition) {
	if (!p) {
		return "";
	}
	const place = p.place_name ? `${p.place_name}, ` : "";
	const city = p.city_name ? p.city_name : "";
	const county = p.county_name ? `${p.county_name}, ` : "";
	const country = p.country_name ? p.country_name : "";
	return `${place}${city} ${county}${country}`;
}
