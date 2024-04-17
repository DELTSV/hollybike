import {
	RouterProvider, createBrowserRouter,
} from "react-router-dom";

export function App() {
	const router = createBrowserRouter([
		{
			path: "/",
			element: <p>{ "root" }</p>,
		},
		{
			path: "/login",
			element: <p>{ "login" }</p>,
		},
	]);

	return <><RouterProvider router={ router } /></>;
}
