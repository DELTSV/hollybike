import { SideBarMenu } from "./SideBarMenu.tsx";
import { useUser } from "../user/useUser.tsx";
import { useMemo } from "preact/hooks";
import { useSideBar } from "./useSideBar.tsx";
import { TAssociation } from "../types/TAssociation.ts";
import { useApi } from "../utils/useApi.ts";
import { TOnPremise } from "../types/TOnPremise.ts";
import { clsx } from "clsx";

export function SideBar() {
	const { user } = useUser();
	const {
		association, visible, setVisible,
	} = useSideBar();
	const onPremise = useApi<TOnPremise>("/on-premise");

	const content = useMemo(() => {
		if (user?.scope === "Root") {
			return rootMenu(association, onPremise.data?.is_on_premise ?? false);
		} else {
			return adminMenu(user?.association, false, onPremise.data?.is_on_premise ?? false);
		}
	}, [user, association]);

	return (
		<div
			className={
				clsx(
					"w-screen md:w-48 fixed md:static left-0 h-screen bg-mantle/80 md:block",
					visible ? "block" : "hidden",
				)
			} style={{ zIndex: 5_000 }}
			onClick={() => setVisible(false)}
		>
			<aside
				className={clsx(
					"w-48 min-w-48 bg-gradient-to-b from-crust to-mantle h-full",
					"flex-col md:flex",
					visible && "flex" || "hidden",
				)}
			>
				{ content }
			</aside>
		</div>
	);
}

function adminMenu(association: TAssociation | undefined, root: boolean, onPremise: boolean) {
	const menus = [
		<SideBarMenu to={`/associations/${association?.id}`}>
			{ root ? association?.name :"Mon association" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/users`}>
			{ root ? `Utilisateurs de ${association?.name}` : "Mes utilisateurs" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/invitations`}>
			{ root ? `Invitations de ${association?.name}` : "Mes Invitations" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/events`}>
			{ root ? `Événements de ${association?.name}` : "Mes événements" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/journeys`}>
			{ root ? `Bibliothèque de ${association?.name}` : "Mes trajets" }
		</SideBarMenu>,
	];
	if (onPremise) {
		menus.push(<SideBarMenu to={"/conf"}>Configuration</SideBarMenu>);
	}
	return menus;
}

function rootMenu(association: TAssociation | undefined, onPremise: boolean) {
	const menu = [
		<SideBarMenu to={"/associations"}>
			Associations
		</SideBarMenu>,
		<SideBarMenu to={"/users"}>
			Utilisateurs
		</SideBarMenu>,
		<SideBarMenu to={"/invitations"}>
			Invitations
		</SideBarMenu>,
		<SideBarMenu to={"/events"}>
			Événements
		</SideBarMenu>,
		<SideBarMenu to={"/journeys"}>
			Bibliothèque de trajet
		</SideBarMenu>,
	];
	if (association !== undefined) {
		menu.push(...adminMenu(association, true, onPremise));
	}
	return menu;
}
