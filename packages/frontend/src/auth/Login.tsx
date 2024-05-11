import {
	useCallback, useEffect, useState,
} from "preact/hooks";
import { useAuth } from "./context.tsx";
import { useNavigate } from "react-router-dom";

export default function () {
	const [email, setEmail] = useState("");
	const [password, setPassword] = useState("");

	const auth = useAuth();

	const login = useCallback(() => {
		auth.login({
			email: email,
			password: password,
		});
	}, [
		email,
		password,
		auth,
	]);

	const navigate = useNavigate();

	useEffect(() => {
		if (auth.isLoggedIn)
			navigate("/");
	}, [auth.isLoggedIn]);

	return (
		<form onSubmit={e => e.preventDefault()}>
			<input
				type={"email"}
				name={"email"}
				placeholder="Email"
				value={email}
				onChange={e => setEmail(e.currentTarget.value)}
			/>
			<input
				type={"password"}
				name={"password"}
				placeholder="Mot de passe" value={password}
				onChange={e => setPassword(e.currentTarget.value)}
			/>
			<button
				onClick={() => {
					login();
				}}
			>
				Valider
			</button>
		</form>
	);
}
