import { SideBarMenu } from "./SideBarMenu.tsx";
import { useUser } from "../user/useUser.tsx";
import { useMemo } from "preact/hooks";
import { useSideBar } from "./useSideBar.tsx";
import { TAssociation } from "../types/TAssociation.ts";

export function SideBar() {
	const { user } = useUser();
	const { association } = useSideBar();

	const content = useMemo(() => {
		if (user?.scope === "Root")
			return rootMenu(association);
		 else
			 return adminMenu(user?.association, false);
	}, [user, association]);

	return (
		<aside
			className={"w-48 min-w-48 bg-gradient-to-b from-slate-50/50 dark:from-slate-800/50" +
			" bg-opacity-50 flex flex-col"}
		>
			{ content }
		</aside>
	);
}

function adminMenu(association: TAssociation | undefined, root: boolean) {
	return [
		<SideBarMenu to={`/associations/${association?.id}`}>
			{ root ? association?.name :"Mon association" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/users`}>
			{ root ? `Utilisateurs de ${association?.name}` : "Mes utilisateurs" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/invitations`}>
			{ root ? `Invitations de ${association?.name}` : "Mes utilisateurs" }
		</SideBarMenu>,
	];
}

function rootMenu(association: TAssociation | undefined) {
	const menu = [
		<SideBarMenu to={"/associations"}>
			Associations
		</SideBarMenu>,
		<SideBarMenu to={"/users"}>
			Utilisateurs
		</SideBarMenu>,
	];
	if (association !== undefined)
		menu.push(...adminMenu(association, true));
	return menu;
}
