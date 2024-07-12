import { Option } from "../components/Select/Select.tsx";

export enum EEventStatus {
	Pending= "Pending",
	Scheduled = "Scheduled",
	Cancelled = "Cancelled",
	Finished = "Finished",
	Now = "Now"
}

export const eventStatus = [
	EEventStatus.Pending,
	EEventStatus.Scheduled,
	EEventStatus.Cancelled,
	EEventStatus.Finished,
	EEventStatus.Now,
];

export const eventStatusOptions: Option[] = [
	{
		name: "En attente",
		value: EEventStatus.Pending,
	},
	{
		name: "Prévu",
		value: EEventStatus.Scheduled,
	},
	{
		name: "Annuler",
		value: EEventStatus.Cancelled,
	},
	{
		name: "Terminer",
		value: EEventStatus.Finished,
	},
	{
		name: "En cours",
		value: EEventStatus.Now,
	},
];
