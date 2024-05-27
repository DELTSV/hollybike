import { SideBarMenu } from "./SideBarMenu.tsx";
import { useUser } from "../user/useUser.tsx";
import { useMemo } from "preact/hooks";
import { useSideBar } from "./useSideBar.tsx";
import { TAssociation } from "../types/TAssociation.ts";

export function SideBar() {
	const { user } = useUser();
	const { association } = useSideBar();

	const content = useMemo(() => {
		if (user?.scope === "Root") {
			const asso = association !== undefined ?
				[
					<SideBarMenu to={`/associations/${association.id}`}>
						{ association?.name }
					</SideBarMenu>,
				] : [];
			const menus = [
				<SideBarMenu to={"/associations"}>
					Associations
				</SideBarMenu>,
				<SideBarMenu to={"/users"}>
					Utilisateurs
				</SideBarMenu>,
			];
			menus.push(...asso);
			return menus;
		} else
			 return adminMenu(user?.association);
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

function adminMenu(association: TAssociation | undefined) {
	return [
		<SideBarMenu to={`/associations/${association?.id}`}>
			Mon association
		</SideBarMenu>,
		<SideBarMenu to={`/association/${association?.id}/users`}>
			Mes utilisateurs
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/invitations`}>
			Mes invitation
		</SideBarMenu>,
	];
}
