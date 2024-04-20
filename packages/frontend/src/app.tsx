import { RouterProvider, createBrowserRouter } from "react-router-dom";
import { AuthContextProvider, AuthenticationGuard } from "./auth";

export function App() {
	const router = createBrowserRouter([
		{
			path: "/",
			element: <AuthenticationGuard/>,
			children: [
				{
					path: "/",
					element: <p>{ "oui" }</p>,
				},
			],
		},
		{
			path: "auth",
			element: <AuthenticationGuard/>,
			children: [
				{
					path: "login",
					element: <p>{ "login" }</p>,
				},
			],
		},
	]);

	return (
		<AuthContextProvider>
			<RouterProvider router={ router } />
		</AuthContextProvider>
	);
}
