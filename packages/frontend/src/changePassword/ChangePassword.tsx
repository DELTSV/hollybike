import {
	useEffect,
	useMemo, useState,
} from "preact/hooks";
import {
	useNavigate, useSearchParams,
} from "react-router-dom";
import { Input } from "../components/Input/Input.tsx";
import { Button } from "../components/Button/Button.tsx";
import { Card } from "../components/Card/Card.tsx";
import { api } from "../utils/useApi.ts";
import { toast } from "react-toastify";

export function ChangePassword() {
	const [password, setPassword] = useState("");
	const [passwordAgain, setPasswordAgain] = useState("");
	const [params] = useSearchParams();
	const navigate = useNavigate();

	const token = useMemo(() => params.get("token"), [params]);
	const user = useMemo(() => params.get("user"), [params]);
	const expire = useMemo(() => params.get("expire"), [params]);

	useEffect(() => {
		if (token === null || user === null || expire === null) {
			navigate("/login");
		}
	}, []);
	return (
		<div className={"flex justify-center items-center h-full"}>
			<Card className={"flex flex-col gap-2"}>
				<h1>Réinitialisation du mot de passe</h1>
				<Input value={user!} disabled/>
				<Input
					value={password}
					type={"password"}
					placeholder={"Mot de passe"}
					onInput={e => setPassword(e.currentTarget.value)}
				/>
				<Input
					value={passwordAgain}
					type={"password"}
					placeholder={"Confirmation du mot de passe"}
					onInput={e => setPasswordAgain(e.currentTarget.value)}
				/>
				<Button
					onClick={() => {
						api(`/users/password/${user}`, {
							body: {
								new_password: password,
								new_password_confirmation: passwordAgain,
								token: token,
								expire: expire,
							},
							method: "PUT",
						}).then((res) => {
							if (res.status === 200) {
								toast("Mot de passe réinitialisé", { type: "success" });
								navigate("/invite");
							} else {
								toast(res.message, { type: "warning" });
							}
						});
					}}
				>
					Réinitialiser le mot de passe
				</Button>
			</Card>
		</div>
	);
}
