import {
	dummyAssociation, TAssociation,
} from "./TAssociation.ts";

export interface TUser {
	id: number,
	username: string,
	email: string,
	scope: string,
	status: string,
	last_login: string,
	association: TAssociation,
	profile_picture?: string
}

export const dummyUser: TUser = {
	id: -1,
	username: "dummy",
	email: "dummy@example.com",
	scope: "None",
	status: "None",
	last_login: "0-0-0T0:0:0",
	association: dummyAssociation,
};
