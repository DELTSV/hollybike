import {Header} from "./header/Header.tsx";
import {useTheme} from "./theme/context.tsx";
import {Outlet} from "react-router-dom";
import {SideBar} from "./sidebar/SideBar.tsx";
import {clsx} from "clsx";

export function Root() {
	const theme = useTheme();

	return (
		<div>
			<div className={clsx(
				"overflow-hidden mx-4 min-h-screen",
				"md:ml-56",
				"transition-ml duration-200",
			)}>
				<Header setTheme={theme.set}/>
				<Outlet/>
			</div>
			<SideBar/>
		</div>
	);
}
