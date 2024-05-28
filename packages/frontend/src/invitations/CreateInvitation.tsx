import { useState } from "preact/hooks";
import { TInvitationCreation } from "../types/TInvitationCreation.ts";
import { Input } from "../components/Input/Input.tsx";
import { useUser } from "../user/useUser.tsx";
import { Button } from "../components/Button/Button.tsx";
import { useNavigate } from "react-router-dom";
import { TInvitation } from "../types/TInvitation.ts";
import { api } from "../utils/useApi.ts";
import { Card } from "../components/Card/Card.tsx";

export function CreateInvitation() {
	const { user } = useUser();

	const [invitation, setInvitation] = useState<TInvitationCreation>({ role: "User" });

	const navigate = useNavigate();

	return (
		<div className={"mx-2"}>
			<Card className={"grid grid-cols-2 gap-2 items-center"}>
				<p>Rôle</p>
				<Input
					value={invitation.role} onInput={e => setInvitation(prev => ({
						...prev,
						role: e.currentTarget.value,
					}))}
				/>
				<p>Expiration</p>
				<Input
					placeholder={"Expiration"}
					value={invitation.expiration ?? ""} onInput={e => setInvitation(prev => ({
						...prev,
						expiration: e.currentTarget.value === "" ? undefined : e.currentTarget.value,
					}))}
				/>
				<p>Utilisation max</p>
				<Input
					placeholder={"Utilisations max"}
					type={"number"}
					value={invitation.maxUses?.toString() ?? ""} onInput={e => setInvitation(prev => ({
						...prev,
						maxUses: e.currentTarget.value === "" ? undefined : parseInt(e.currentTarget.value),
					}))}
				/>
				{ user?.scope === "Root" &&
				<>
					<p>Association</p>
					<Input
						value={invitation.association?.toString() ?? ""} onInput={e => setInvitation(prev => ({
							...prev,
							association: e.currentTarget.value === "" ? undefined : parseInt(e.currentTarget.value),
						}))}
					/>
				</> }
				<Button
					className={"col-span-2 justify-self-center"}
					onClick={() => {
						api<TInvitation>("/invitation", {
							method: "POST",
							body: invitation,
						}).then((res) => {
							if (res.status === 200)
								navigate(-1);
						 else
								console.log(res.message);
						});
					}}
				>
					Créer
				</Button>
			</Card>
		</div>
	);
}
