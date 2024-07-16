/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { TPosition } from "./TPosition.ts";

export interface TJourneyPartial {
	id: number,
	name: string,
	file?: string,
	preview_image?: string,
	start?: TPosition,
	end?: TPosition,
	destination?: TPosition,
	totalDistance?: number,
	minElevation?: number,
	maxElevation?: number,
	totalElevationGain?: number,
	totalElevationLoss?: number
}
