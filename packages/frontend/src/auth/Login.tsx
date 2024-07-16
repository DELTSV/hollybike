/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	useCallback, useEffect, useState,
} from "preact/hooks";
import { useAuth } from "./context.tsx";
import { useNavigate } from "react-router-dom";
import { Input } from "../components/Input/Input.tsx";
import { Button } from "../components/Button/Button.tsx";
import { Card } from "../components/Card/Card.tsx";
import { Modal } from "../components/Modal/Modal.tsx";
import { api } from "../utils/useApi.ts";
import { toast } from "react-toastify";
import success = toast.success;

export default function () {
	const [email, setEmail] = useState("");
	const [password, setPassword] = useState("");
	const [visible, setVisible] = useState(false);
	const [forgotMail, setForgotMail] = useState("");

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
		if (auth.isLoggedIn) {
			navigate("/");
		}
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
					<button
						className={"hover:scale-105 hover:bg-crust p-2 rounded-full transition"}
						onClick={() => setVisible(true)}
					>
						Mot de passe oublié
					</button>
				</Card>
			</form>
			<Modal visible={visible} setVisible={setVisible} title={"Mot de passe oublié"}>
				<div className={"flex flex-col items-center gap-4"}>
					<Input value={forgotMail} onInput={e => setForgotMail(e.currentTarget.value)} placeholder={"Email"}/>
					<Button
						onClick={
							() => api(`/users/password/${forgotMail}/send`, { method: "POST" }).then((res) => {
								if (res.status === 200) {
									success("Mail envoyé");
									setVisible(false);
								} else {
									toast(res.message, { type: "error" });
								}
							})
						}
						disabled={forgotMail === ""}
					>
						Envoyer le mail
					</Button>
				</div>
			</Modal>
		</div>
	);
}
