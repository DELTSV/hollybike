import { Option } from "../components/Select/Select.tsx";

export enum EUserScope {
	User = "User",
	Admin = "Admin",
	Root = "Root"
}

export const scopes = Object.values(EUserScope);

export const scopesName = {
	User: "Utilisateur",
	Admin: "Administrateur",
	Root: "Super Administrateur",
};

export const EUserScopeOptions: Option[] = [
	{
		name: "Utilisateur",
		value: EUserScope.User,
	},
	{
		name: "Administrateur",
		value: EUserScope.Admin,
	},
	{
		name: "Super Administrateur",
		value: EUserScope.Root,
	},
];

export function EUserScopeToString(v: EUserScope) {
	switch (v) {
	case EUserScope.User: return "Utilisateur";
	case EUserScope.Admin: return "Administrateur";
	case EUserScope.Root: return "Super Administrateur";
	}
}
