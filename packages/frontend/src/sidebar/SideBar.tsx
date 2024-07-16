/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { SideBarMenu } from "./SideBarMenu.tsx";
import { useUser } from "../user/useUser.tsx";
import { useMemo } from "preact/hooks";
import { useSideBar } from "./useSideBar.tsx";
import { TAssociation } from "../types/TAssociation.ts";
import { useApi } from "../utils/useApi.ts";
import { TOnPremise } from "../types/TOnPremise.ts";
import { clsx } from "clsx";
import { CloseRounded } from "@material-ui/icons";
import { Link } from "react-router-dom";

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
					"fixed left-0 right-0 top-0 bottom-0 md:bg-transparent p-4",
					"transition-backdrop-filter-bg duration-200",
					"group/background",
					visible ?
						clsx(
							"bg-crust/40 backdrop-blur-sm pointer-events-auto cursor-pointer",
							"[&:hover:not(:has(aside:hover))]:bg-crust/10 [&:hover:not(:has(aside:hover))]:backdrop-blur-[1px]",
							"[&:has(aside>button:hover)]:bg-crust/10 [&:has(aside>button:hover)]:backdrop-blur-[1px]",
						) :
						"!bg-none backdrop-blur-0 pointer-events-none",
				)
			}
			style={{ zIndex: 8_000 }}
			onClick={() => setVisible(false)}
		>
			<aside
				className={clsx(
					"relative w-48 min-w-48 bg-base h-full rounded-xl shadow-lg shadow-black/50 pointer-events-auto",
					"flex-col flex md:translate-x-0 gap-2 p-2",
					"transition-transform duration-200 cursor-auto",
					visible ? "translate-x-0" : "-translate-x-[calc(100%+4rem)]",
				)}
			>
				<Link className={"self-stretch"} to={"/"}>
					<p
						className={clsx(
							"text-white flex overflow-hidden h-24 rounded",
							"relative justify-center items-center bg-logo",
						)}
					>
						<img alt={"HOLLYBIKE"} className={"text-black text-3xl italic"} src={"/icon.png"}/>
					</p>
				</Link>
				<button
					className={clsx(
						"absolute bg-subtext-1 text-base fill-base rounded p-1",
						"origin-top-left md:scale-0 md:-mb-10",
						"transition-transform-w duration-200",
						"flex gap-1 items-center w-8 hover:w-24 group-[&:hover:not(:has(:hover))]/background:w-24",
						"outline outline-base outline-8",
						"group/button overflow-clip",
					)}
					onClick={() => setVisible(false)}
				>
					<CloseRounded/>
					<p
						className={clsx(
							"translate-x-8 translate-y-8 opacity-0",
							"transition-transform duration-200",
							"group-hover/button:translate-x-0 group-hover/button:translate-y-0 group-hover/button:opacity-100",
							"group-[&:hover:not(:has(:hover))]/background:translate-x-0",
							"group-[&:hover:not(:has(:hover))]/background:translate-y-0",
							"group-[&:hover:not(:has(:hover))]/background:opacity-100",
						)}
					>
						Fermer
					</p>
				</button>
				<div className={clsx("h-full flex flex-col overflow-y-auto")}>
					{ content }
				</div>
			</aside>
		</div>
	);
}

function adminMenu(association: TAssociation | undefined, root: boolean, onPremise: boolean) {
	let menus = [
		<SideBarMenu to={`/associations/${association?.id}`}>
			{ root ? association?.name : "Mon association" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/invitations`} indent={root}>
			{ root ? "Invitations" : "Mes invitations" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/users`} indent={root}>
			{ root ? "Utilisateurs" : "Mes utilisateurs" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/events`} indent={root}>
			{ root ? "Événements" : "Mes événements" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/journeys`} indent={root}>
			{ root ? "Bibliothèque de trajet" : "Mes trajets" }
		</SideBarMenu>,
	];
	if (onPremise) {
		menus.push(<SideBarMenu to={"/conf"}>Configuration</SideBarMenu>);
	}
	if (root) {
		menus = [<div className={"w-3/5 bg-gray-600 h-0.5 my-1"}/>, ...menus];
	}
	return menus;
}

function rootMenu(association: TAssociation | undefined, onPremise: boolean) {
	const menu = [
		<SideBarMenu to={"/associations"}>
			Associations
		</SideBarMenu>,
		<SideBarMenu to={"/invitations"}>
			Invitations
		</SideBarMenu>,
		<SideBarMenu to={"/users"}>
			Utilisateurs
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
