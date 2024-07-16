/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { EAssociationStatus } from "./EAssociationStatus.ts";

export interface TAssociation {
	id: number,
	name: string,
	status: EAssociationStatus,
	picture?: string
}

export const dummyAssociation: TAssociation = {
	id: -1,
	name: "dummyAssociation",
	status: EAssociationStatus.Enabled,
};
