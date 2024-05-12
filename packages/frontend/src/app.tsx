import {
	RouterProvider, createBrowserRouter,
} from "react-router-dom";
import Login from "./auth/Login.tsx";
import { Home } from "./home/Home.tsx";
import { useEffect } from "preact/hooks";
import { useAuth } from "./auth/context.tsx";
import { useTheme } from "./theme/context.tsx";

export function App() {
	const auth = useAuth();
	const theme = useTheme();
	const router = createBrowserRouter([
		{
			path: "/",
			element: <Home/>,
		},
		{
			path: "/login",
			element: <Login/>,
		},
	]);

	useEffect(() => {
		if (!auth.isLoggedIn)
			router.navigate("/login");
	}, [auth.isLoggedIn]);

	return (
		<main className={theme.theme}>
			<button onClick={() => theme.set("light")}>SetLight</button>
			<button onClick={() => theme.set("dark")}>SetDark</button>
			<button onClick={() => theme.set("os")}>SetOS</button>
			<RouterProvider router={ router } />
		</main>
	);
}
