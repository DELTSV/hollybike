import {Header} from "./header/Header.tsx";
import {useTheme} from "./theme/context.tsx";
import {Outlet} from "react-router-dom";
import {SideBar} from "./sidebar/SideBar.tsx";
import {clsx} from "clsx";

export function Root() {
	const theme = useTheme();

	return (
		<div className={"flex flex-col h-full overflow-hidden"}>
			<Header setTheme={theme.set}/>
			<div className={clsx(
				"overflow-hidden mx-4",
				"md:ml-56",
				"transition-ml duration-200",
			)}>
				<SideBar/>
				<Outlet/>
			</div>
		</div>
	);
}
