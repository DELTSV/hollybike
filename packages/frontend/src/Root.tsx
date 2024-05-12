import { Header } from "./header/Header.tsx";
import { useTheme } from "./theme/context.tsx";
import { Outlet } from "react-router-dom";

export function Root() {
	const theme = useTheme();

	return (
		<>
			<Header setTheme={theme.set}/>
			<Outlet/>
		</>
	);
}
