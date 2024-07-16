/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { EUserScope } from "./EUserScope.ts";
import { EUserStatus } from "./EUserStatus.ts";
import { EEventRole } from "./EEventRole.ts";

export interface TUserPartial {
	id: number,
	username: string,
	scope: EUserScope,
	status: EUserStatus,
	profile_picture?: string,
	event_role?: EEventRole,
	is_owner?: boolean,
	role?: string
}
