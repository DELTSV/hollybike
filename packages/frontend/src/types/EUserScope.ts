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
