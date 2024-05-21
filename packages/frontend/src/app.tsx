import {
	RouterProvider, createBrowserRouter,
} from "react-router-dom";
import Login from "./auth/Login.tsx";
import {
	useEffect, useMemo, useState,
} from "preact/hooks";
import { useAuth } from "./auth/context.tsx";
import { useTheme } from "./theme/context.tsx";
import { Root } from "./Root.tsx";
import { Home } from "./home/Home.tsx";
import { clsx } from "clsx";
import { useSystemDarkMode } from "./utils/systemDarkMode.ts";
import { ListAssociations } from "./associations/listAssociations/ListAssociations.tsx";
import { Association } from "./associations/Association.tsx";
import { ListUser } from "./user/listUser/ListUser.tsx";
import { useApi } from "./utils/useApi.ts";
import { TConfDone } from "./types/GConfDone.ts";
import { Conf } from "./conf/Conf.tsx";

export function App() {
	const [loaded, setLoaded] = useState(false);
	const auth = useAuth();
	const theme = useTheme();
	const systemDark = useSystemDarkMode();
	const router = createBrowserRouter([
		{
			path: "/",
			element: <Root/>,
			children: [
				{
					path: "/",
					element: <Home/>,
				},
				{
					path: "associations",
					element: <ListAssociations/>,
				},
				{
					path: "associations/:id",
					element: <Association/>,
				},
				{
					path: "users",
					element: <ListUser/>,
				},
				{
					path: "conf",
					element: <Conf/>,
				},
			],
		},
		{
			path: "/login",
			element: <Login/>,
		},
		{
			path: "/forbidden",
			element: <p>"Interdit d'être ici"</p>,
		},
		{
			path: "/conf-mode",
			element: <Conf/>,
		},
	]);

	const confMode = useApi<TConfDone, never>("/conf-done");

	useEffect(() => {
		if (!auth.loading)
			setLoaded(true);
	}, [auth.loading]);

	useEffect(() => {
		if (loaded)
			if (confMode.data?.conf_done === false)
				router.navigate("/conf-mode");
			else if (!auth.isLoggedIn)
				router.navigate("/login");
	}, [confMode, auth.isLoggedIn]);

	const themeDark = useMemo(() => theme.theme === "dark" || theme.theme === "os" && systemDark, [theme.theme]);

	return (
		<main
			className={clsx(themeDark && "dark", "bg-slate-200 dark:bg-gray-900 w-screen h-screen" +
				" text-slate-950 dark:text-slate-100")}
		>
			<RouterProvider router={ router } />
		</main>
	);
}
