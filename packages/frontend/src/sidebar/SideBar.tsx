import { SideBarMenu } from "./SideBarMenu.tsx";

export function SideBar() {
	return (
		<aside className={"w-48 bg-gradient-to-b from-slate-50/50 dark:from-slate-800/50 bg-opacity-50 flex flex-col"}>
			<SideBarMenu to={"/test"}>
				Test
			</SideBarMenu>
		</aside>
	);
}
