import {
	RouterProvider, createBrowserRouter,
} from "react-router-dom";
import Login from "./auth/Login.tsx";
import {
	useEffect, useMemo,
} from "preact/hooks";
import { useAuth } from "./auth/context.tsx";
import { useTheme } from "./theme/context.tsx";
import { Root } from "./Root.tsx";
import { Home } from "./home/Home.tsx";
import { clsx } from "clsx";
import { useSystemDarkMode } from "./utils/systemDarkMode.ts";
import { ListAssociations } from "./listAssociations/ListAssociations.tsx";

export function App() {
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
					path: "list-asso",
					element: <ListAssociations/>,
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
	]);

	useEffect(() => {
		if (!auth.isLoggedIn)
			router.navigate("/login");
	}, [auth.isLoggedIn]);

	const themeDark = useMemo(() => theme.theme === "dark" || theme.theme === "os" && systemDark, [theme.theme]);

	return (
		<main className={clsx(themeDark && "dark", "bg-slate-200 dark:bg-gray-900 w-screen h-screen text-slate-950 dark:text-slate-100")}>
			<RouterProvider router={ router } />
		</main>
	);
}
