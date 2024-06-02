import { TUserPartial } from "./TUserPartial.ts";
import { EEventStatus } from "./EEventStatus.ts";

export interface TEvent {
	id: number,
	name: string,
	description?: string,
	image?: string,
	status: EEventStatus,
	owner: TUserPartial,
	start_date_time: string
	end_date_time?: string,
	create_date_time: string,
	update_date_time: string
}
