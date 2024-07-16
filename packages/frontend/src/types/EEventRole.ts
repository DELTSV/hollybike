/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Option } from "../components/Select/Select.tsx";

export enum EEventRole {
	Member = "Member",
	Organizer = "Organizer"
}

export const EEventRoleOptions: Option[] = [
	{
		name: "Membre",
		value: EEventRole.Member,
	},
	{
		name: "Organisateur",
		value: EEventRole.Organizer,
	},
];
