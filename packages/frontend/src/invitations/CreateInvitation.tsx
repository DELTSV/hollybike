import {
	useEffect, useMemo, useState,
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
import {
	EUserScope, scopes, scopesName,
} from "../types/EUserScope.ts";
import { RedStar } from "../components/RedStar/RedStar.tsx";

const expirationOptions: Option[] = [
	{
		name: "Dans 1 heure",
		value: 1,
	},
	{
		name: "Dans 6 heures",
		value: 6,
	},
	{
		name: "Dans 1 jour",
		value: 24,
	},
	{
		name: "Dans 1 mois",
		value: -1,
	},
	{
		name: "Jamais",
		value: 0,
	},
];

function getDate(hours: number) {
	if (hours === 0) { return undefined; } else if (hours === -1) {
		const now = new Date();
		now.setMonth(now.getMonth() + 1);
		return now;
	} else {
		const now = new Date();
		now.setHours(now.getHours() + hours);
		return now;
	}
}

export function CreateInvitation() {
	const { user } = useUser();

	const [invitation, setInvitation] = useState<TInvitationCreation>({ role: "User" });

	const navigate = useNavigate();

	const [total, setTotal] = useState(20);

	const associations = useApi<TList<TAssociation>>(
		`/associations?per_page=${total}`,
		[],
		{ if: user?.scope === EUserScope.Root },
	);

	const options: Option[] | undefined = useMemo(() => associations.data?.data?.map(a => ({
		name: a.name,
		value: a.id,
	})), [associations]);

	useEffect(() => {
		if (associations.data?.total_data !== undefined) { setTotal(associations.data?.total_data); }
	}, [associations.data?.total_data]);

	const [expire, setExpire] = useState<number>(1);

	useEffect(() => {
		setInvitation(prev => ({
			...prev,
			expiration: getDate(expire)?.toISOString(),
		}));
	}, [expire]);

	const scopeOptions: Option[] = useMemo(() =>
		scopes.filter(s => user?.scope === EUserScope.Root || s !== "Root").map(s => ({
			name: scopesName[s],
			value: s,
		})), [user]);

	return (
		<div className={"mx-2"}>
			<Card className={"grid grid-cols-2 gap-2 items-center"}>
				<p>Rôle <RedStar/></p>
				<Select
					default={invitation.role}
					value={invitation.role} onChange={v => setInvitation(prev => ({
						...prev,
						role: v as EUserScope,
					}))}
					options={scopeOptions}
				/>
				<p>Expiration</p>
				<Select
					default={expire}
					value={expire} onChange={v => setExpire(parseInt((v ?? "0").toString()))}
					options={expirationOptions}
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
					<p>Association <RedStar/></p>
					<Select
						options={options ?? []}
						searchable={(associations.data?.total_data ?? 0) > 5}
						value={invitation.association}
						onChange={v => setInvitation(prev => ({
							...prev,
							association: v as number,
						}))}
					/>
				</> }
				<Button
					disabled={user?.scope === EUserScope.Root && invitation.association === undefined}
					className={"col-span-2 justify-self-center"}
					onClick={() => {
						api<TInvitation>("/invitation", {
							method: "POST",
							body: invitation,
						}).then((res) => {
							if (res.status === 200) {
								navigate(-1);
							} else if (res.status === 404) {
								toast("L'association n'existe pas/plus", { type: "warning" });
							} else if (res.status === 409) {
								toast(res.message, { type: "warning" });
							} else {
								toast(res.message, { type: "error" });
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
