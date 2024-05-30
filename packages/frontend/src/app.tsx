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
import { UserDetail } from "./user/userDetail/UserDetail.tsx";
import { ListInvitations } from "./invitations/ListInvitations.tsx";
import { CreateInvitation } from "./invitations/CreateInvitation.tsx";
import { CreateAssociation } from "./associations/CreateAssociation.tsx";

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
					path: "associations/new",
					element: <CreateAssociation/>,
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
					path: "users/:id",
					element: <UserDetail/>,
				},
				{
					path: "associations/:id/invitations",
					element: <ListInvitations/>,
				},
				{
					path: "associations/:id/users",
					element: <ListUser/>,
				},
				{
					path: "invitations/new",
					element: <CreateInvitation/>,
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

	const confMode = useApi<TConfDone>("/conf-done");

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
