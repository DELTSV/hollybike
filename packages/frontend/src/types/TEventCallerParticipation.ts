/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { EEventRole } from "./EEventRole.ts";

export interface TEventCallerParticipation {
	role: EEventRole,
	userId: number,
	isImagePublic: boolean,
	joinedDateTime: Date
}
