import {Header} from "./header/Header.tsx";
import {useTheme} from "./theme/context.tsx";
import {Outlet} from "react-router-dom";
import {SideBar} from "./sidebar/SideBar.tsx";
import {clsx} from "clsx";

export function Root() {
	const theme = useTheme();

	return <>
		<div className={clsx(
			"overflow-hidden min-h-screen m-4",
			"flex flex-col gap-2 md:ml-56",
			"transition-ml duration-200",
		)}>
			<Header setTheme={theme.set}/>
			<Outlet/>
		</div>
		<SideBar/>
	</>;
}
