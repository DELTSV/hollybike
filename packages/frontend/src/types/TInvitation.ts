/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { TAssociation } from "./TAssociation.ts";
import { EUserScope } from "./EUserScope.ts";

export interface TInvitation {
	id: number,
	role: EUserScope,
	status: string,
	expiration: string,
	creation: string,
	uses: number,
	max_uses: number | null,
	label?: string,
	link?: string,
	association: TAssociation
}
