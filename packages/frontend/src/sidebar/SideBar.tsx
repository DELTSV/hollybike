import { SideBarMenu } from "./SideBarMenu.tsx";
import { useUser } from "../user/useUser.tsx";
import { useMemo } from "preact/hooks";
import { useSideBar } from "./useSideBar.tsx";

export function SideBar() {
	const { user } = useUser();
	const { association } = useSideBar();

	const content = useMemo(() => {
		if (user?.scope === "Root")
			return [
				<SideBarMenu to={"/associations"}>
					Associations
				</SideBarMenu>,
				<SideBarMenu to={"/users"}>
					Utilisateurs
				</SideBarMenu>,
				association !== undefined &&
					<SideBarMenu to={`/associations/${ association.id}`}>
						{ association?.name }
					</SideBarMenu>,
			];
		 else
			 return [
				 <SideBarMenu to={`/associations/${ user?.association.id}`}>
					 Mon Association
				 </SideBarMenu>,
			 ];
	}, [user, association]);

	return (
		<aside className={"w-48 bg-gradient-to-b from-slate-50/50 dark:from-slate-800/50 bg-opacity-50 flex flex-col"}>
			{ content }
		</aside>
	);
}
