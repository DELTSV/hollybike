/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";
import { Button } from "../components/Button/Button.tsx";
import { useState } from "preact/hooks";
import {
	dummyNewAsso, TNewAsso,
} from "../types/TNewAsso.ts";
import { api } from "../utils/useApi.ts";
import { useNavigate } from "react-router-dom";
import { toast } from "react-toastify";
import { TAssociation } from "../types/TAssociation.ts";
import { RedStar } from "../components/RedStar/RedStar.tsx";

export function CreateAssociation() {
	const navigate = useNavigate();
	const [newAsso, setNewAsso] = useState<TNewAsso>(dummyNewAsso);
	return (
		<div>
			<Card className={"grid grid-cols-2 gap-2"}>
				<p>Nom de l'association <RedStar/></p>
				<Input
					value={newAsso.name} onInput={e => setNewAsso(prev => ({
						...prev,
						name: e.currentTarget.value,
					}))}
				/>
				<Button
					disabled={newAsso.name === ""}
					className={"col-span-2 justify-self-center"} onClick={() => {
						api<TAssociation>("/associations", {
							method: "POST",
							body: newAsso,
						}).then((res) => {
							if (res.status === 201) {
								toast("Association créer", { type: "success" });
								navigate(`/associations/${res.data?.id}`);
							} else if (res.status === 409) {
								toast(res.message, { type: "warning" });
							} else {
								toast(`Erreur: ${ res.message}`, { type: "error" });
							}
						});
					}}
				>
					Créer
				</Button>
			</Card>
		</div>
	);
}
