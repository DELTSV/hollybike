/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { TUserPartial } from "./TUserPartial.ts";
import { EEventRole } from "./EEventRole.ts";
import { TUserJourney } from "./TUserJourney.ts";

export interface TEventParticipation {
	user: TUserPartial,
	role: EEventRole,
	isImagePublic: boolean,
	joinedDateTime: Date,
	journey?: TUserJourney
}
