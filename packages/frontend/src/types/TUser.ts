import {
	dummyAssociation, TAssociation,
} from "./TAssociation.ts";
import { EUserScope } from "./EUserScope.ts";
import { EUserStatus } from "./EUserStatus.ts";

export interface TUser {
	id: number,
	username: string,
	email: string,
	scope: EUserScope,
	status: EUserStatus,
	last_login: string,
	association: TAssociation,
	profile_picture?: string
}

export const dummyUser: TUser = {
	id: -1,
	username: "dummy",
	email: "dummy@example.com",
	scope: EUserScope.User,
	status: EUserStatus.Enabled,
	last_login: "0-0-0T0:0:0",
	association: dummyAssociation,
};
