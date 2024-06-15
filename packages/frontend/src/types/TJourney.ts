import { TUserPartial } from "./TUserPartial.ts";
import { TPartialAssociation } from "./TPartialAssociation.ts";

export interface TJourney {
	id: number,
	name: string,
	file?: string,
	created_at: Date,
	creator: TUserPartial,
	association: TPartialAssociation
}
