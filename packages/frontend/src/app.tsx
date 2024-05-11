import {
	RouterProvider, createBrowserRouter,
} from "react-router-dom";
import Login from "./auth/Login.tsx";
import { Home } from "./home/Home.tsx";
import { useEffect } from "preact/hooks";
import { useAuth } from "./auth/context.tsx";

export function App() {
	const auth = useAuth();
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

	return <><RouterProvider router={ router } /></>;
}
