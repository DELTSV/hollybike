import {
	useEffect,
	useMemo, useState,
} from "preact/hooks";
import { TInvitationCreation } from "../types/TInvitationCreation.ts";
import { Input } from "../components/Input/Input.tsx";
import { useUser } from "../user/useUser.tsx";
import { Button } from "../components/Button/Button.tsx";
import { useNavigate } from "react-router-dom";
import { TInvitation } from "../types/TInvitation.ts";
import {
	api, useApi,
} from "../utils/useApi.ts";
import { Card } from "../components/Card/Card.tsx";
import { toast } from "react-toastify";
import {
	Option, Select,
} from "../components/Select/Select.tsx";
import { TAssociation } from "../types/TAssociation.ts";
import { TList } from "../types/TList.ts";

export function CreateInvitation() {
	const { user } = useUser();

	const [invitation, setInvitation] = useState<TInvitationCreation>({ role: "User" });

	const navigate = useNavigate();

	const [total, setTotal] = useState(20);

	const associations = useApi<TList<TAssociation>>(`/associations?per_page=${total}`);

	const options: Option[] | undefined = useMemo(() => associations.data?.data?.map(a => ({
		name: a.name,
		value: a.id,
	})), [associations]);

	useEffect(() => {
		if (associations.data?.total_data !== undefined)
			setTotal(associations.data?.total_data);
	}, [associations.data?.total_data]);

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
					<Select options={options ?? []} searchable={(associations.data?.total_data ?? 0) > 5}/>
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
							else if (res.status === 404)
								toast("L'association n'existe pas/plus", { type: "warning" });
							else if (res.status === 409)
								toast(res.message, { type: "warning" });
							else
								toast(res.message, { type: "error" });
						});
					}}
				>
					Créer
				</Button>
			</Card>
		</div>
	);
}
