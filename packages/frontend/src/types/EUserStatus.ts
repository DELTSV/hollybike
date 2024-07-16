/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Option } from "../components/Select/Select.tsx";

export enum EUserStatus {
	Enabled = "Enabled",
	Disabled = "Disabled"
}

export const EUserStatusOptions: Option[] = [
	{
		name: "Activé",
		value: EUserStatus.Enabled,
	},
	{
		name: "Désactivé",
		value: EUserStatus.Disabled,
	},
];

export function EUserStatusToString(v: EUserStatus) {
	switch (v) {
	case EUserStatus.Enabled: return "Activé";
	case EUserStatus.Disabled: return "Désactivé";
	}
}
