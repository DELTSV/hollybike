import { TUserPartial } from "./TUserPartial.ts";
import { EEventStatus } from "./EEventStatus.ts";
import { TAssociationPartial } from "./TAssociationPartial.ts";

export interface TEvent {
	id: number,
	name: string,
	description?: string,
	image?: string,
	status: EEventStatus,
	owner: TUserPartial,
	start_date_time: Date
	end_date_time?: Date,
	create_date_time: Date,
	update_date_time: Date,
	association: TAssociationPartial
}
