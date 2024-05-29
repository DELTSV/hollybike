import { Header } from "./header/Header.tsx";
import { useTheme } from "./theme/context.tsx";
import { Outlet } from "react-router-dom";
import { SideBar } from "./sidebar/SideBar.tsx";

export function Root() {
	const theme = useTheme();

	return (
		<div className={"flex flex-col h-full overflow-hidden"}>
			<Header setTheme={theme.set}/>
			<div className={"flex grrunow"}>
				<SideBar/>
				<Outlet/>
			</div>
		</div>
	);
}
