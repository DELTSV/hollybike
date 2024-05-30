import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";
import { Button } from "../components/Button/Button.tsx";
import { useState } from "preact/hooks";
import {
	dummyNewAsso, TNewAsso,
} from "../types/TNewAsso.ts";
import { api } from "../utils/useApi.ts";
import { useNavigate } from "react-router-dom";

export function CreateAssociation() {
	const navigate = useNavigate();
	const [newAsso, setNewAsso] = useState<TNewAsso>(dummyNewAsso);
	return (
		<div>
			<Card className={"grid grid-cols-2 gap-2"}>
				<p>Nom de l'association</p>
				<Input
					value={newAsso.name} onInput={e => setNewAsso(prev => ({
						...prev,
						name: e.currentTarget.value,
					}))}
				/>
				<Button
					className={"col-span-2 justify-self-center"} onClick={() => {
						api("/associations", {
							method: "POST",
							body: newAsso,
						}).then((res) => {
							if (res.status === 201)
								navigate(-1);
						});
					}}
				>
					Créer
				</Button>
			</Card>
		</div>
	);
}
