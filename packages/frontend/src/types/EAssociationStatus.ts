/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Option } from "../components/Select/Select.tsx";

export enum EAssociationStatus {
	Enabled = "Enabled",
	Disabled = "Disabled",
}

export const EAssociationStatusOptions: Option[] = [
	{
		name: "Active",
		value: "Enabled",
	},
	{
		name: "Inactive",
		value: "Disabled",
	},
];

export function EAssociationStatusToString(v: EAssociationStatus) {
	switch (v) {
	case EAssociationStatus.Enabled:return "Activé";
	case EAssociationStatus.Disabled:return "Désactivé";
	}
}
