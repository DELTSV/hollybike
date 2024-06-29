import { EEventRole } from "./EEventRole.ts";

export interface TEventCallerParticipation {
	role: EEventRole,
	userId: number,
	isImagePublic: boolean,
	joinedDateTime: Date
}
