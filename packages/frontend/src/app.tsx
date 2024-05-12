import {
	RouterProvider, createBrowserRouter,
} from "react-router-dom";
import Login from "./auth/Login.tsx";
import { useEffect } from "preact/hooks";
import { useAuth } from "./auth/context.tsx";
import { useTheme } from "./theme/context.tsx";
import { Root } from "./Root.tsx";
import { Home } from "./home/Home.tsx";

export function App() {
	const auth = useAuth();
	const theme = useTheme();
	const router = createBrowserRouter([
		{
			path: "/",
			element: <Root/>,
			children: [
				{
					path: "/",
					element: <Home/>,
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

	return (
		<main className={theme.theme}>
			<RouterProvider router={ router } />
		</main>
	);
}
