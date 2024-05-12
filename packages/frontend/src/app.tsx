import {
	RouterProvider, createBrowserRouter,
} from "react-router-dom";
import Login from "./auth/Login.tsx";
import { Home } from "./home/Home.tsx";
import { useEffect } from "preact/hooks";
import { useAuth } from "./auth/context.tsx";
import { useTheme } from "./theme/context.tsx";
import { Header } from "./header/Header.tsx";

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
			<Header setTheme={theme.set}/>
			<RouterProvider router={ router } />
		</main>
	);
}
