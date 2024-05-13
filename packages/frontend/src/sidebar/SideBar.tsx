import { SideBarMenu } from "./SideBarMenu.tsx";
import { useUser } from "../user/useUser.tsx";
import { useMemo } from "preact/hooks";

export function SideBar() {
	const { user } = useUser();

	const rootContent = useMemo(() => {
		if (user?.scope === "Root")
			return [
				<SideBarMenu to={"/list-asso"}>
					Associations
				</SideBarMenu>,
			];
		 else
			 return [];
	}, [user]);

	return (
		<aside className={"w-48 bg-gradient-to-b from-slate-50/50 dark:from-slate-800/50 bg-opacity-50 flex flex-col"}>
			{ rootContent }
		</aside>
	);
}
