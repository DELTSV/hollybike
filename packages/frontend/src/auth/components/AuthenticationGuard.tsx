import { useContext, useMemo } from "preact/hooks";
import { Auth } from "../context.tsx";
import { Outlet } from "react-router-dom";

type Props = {
	shouldBeAuthenticated: boolean,
	redirectionRoute: string,
}

export const AuthenticationGuard = ({ shouldBeAuthenticated }: Props) => {
	const { isLoggedIn, token } = useContext(Auth);
	const message = useMemo(
		() => isLoggedIn ? `You are connected with token ${token}` : "You are not connected",
		[ isLoggedIn, token ],
	);

	return (
		<>
			<p>{ "should be authenticated: " }{ shouldBeAuthenticated }</p>
			<p>{ message }</p>
			<Outlet />
		</>
	);
};
