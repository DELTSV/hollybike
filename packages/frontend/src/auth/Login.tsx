import {
	useCallback, useEffect, useState,
} from "preact/hooks";
import { useAuth } from "./context.tsx";
import { useNavigate } from "react-router-dom";
import { Input } from "../components/Input/Input.tsx";
import { Button } from "../components/Button/Button.tsx";
import { Card } from "../components/Card/Card.tsx";

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
		<div className={" w-full h-full flex justify-center items-center"}>
			<form onSubmit={e => e.preventDefault()}>
				<Card className={"flex flex-col items-center gap-4"}>
					<p className={"text-2xl"}>Bienvenue sur l'interface de gestion d'Hollybike</p>
					<Input
						type={"email"}
						placeholder="Email"
						value={email}
						onInput={e => setEmail(e.currentTarget.value)}
					/>
					<Input
						type={"password"}
						placeholder="Mot de passe" value={password}
						onInput={e => setPassword(e.currentTarget.value)}
					/>
					<Button
						onClick={() => {
							login();
						}}
					>
						Valider
					</Button>
				</Card>
			</form>
		</div>
	);
}
