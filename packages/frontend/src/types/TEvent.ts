import { TUserPartial } from "./TUserPartial.ts";
import { EEventStatus } from "./EEventStatus.ts";
import { TAssociationPartial } from "./TAssociationPartial.ts";
import { dummyUser } from "./TUser.ts";
import { dummyAssociation } from "./TAssociation.ts";

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

export const dummyEvent: TEvent = {
	id: -1,
	name: "dummy",
	status: EEventStatus.Pending,
	owner: dummyUser,
	start_date_time: new Date(),
	create_date_time: new Date(),
	update_date_time: new Date(),
	association: dummyAssociation,
};
