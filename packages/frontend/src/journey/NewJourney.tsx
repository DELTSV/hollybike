/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";
import {
	useCallback, useEffect, useMemo, useState,
} from "preact/hooks";
import { useUser } from "../user/useUser.tsx";
import { EUserScope } from "../types/EUserScope.ts";
import {
	Option, Select,
} from "../components/Select/Select.tsx";
import { FileInput } from "../components/Input/FileInput.tsx";
import {
	api, apiRaw, useApi,
} from "../utils/useApi.ts";
import { TList } from "../types/TList.ts";
import { TAssociation } from "../types/TAssociation.ts";
import { TJourney } from "../types/TJourney.ts";
import { Button } from "../components/Button/Button.tsx";
import { useNavigate } from "react-router-dom";
import { toast } from "react-toastify";

export function NewJourney() {
	const { user } = useUser();
	const navigate = useNavigate();
	const [name, setName] = useState("");
	const [journeyFile, setJourneyFile] = useState<File | null>(null);
	const [association, setAssociation] = useState(-1);

	const [loading, setLoading] = useState(false);

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

	useEffect(() => {
		if (user?.scope === EUserScope.Admin) {
			setAssociation(user.association.id);
		}
	}, [user]);

	const createJourney = useCallback(() => {
		api<TJourney>("/journeys", {
			method: "POST",
			body: {
				name: name,
				association: association,
			},
		}).then((res) => {
			if (res.data !== undefined && res.status === 201) {
				const fd = new FormData();
				fd.append("file", journeyFile!);
				const { id } = res.data;
				apiRaw(`/journeys/${id}/file`, undefined, {
					method: "POST",
					body: fd,
				}).then((res) => {
					if (res.status === 200) {
						toast("Trajet créé", { type: "success" });
						navigate("/journeys");
					} else {
						toast(res.message, { type: "error" });
					}
					setLoading(false);
				});
			} else {
				setLoading(false);
				toast(res.message, { type: "error" });
			}
		});
	}, [
		name,
		association,
		journeyFile,
		setLoading,
		navigate,
	]);

	return (
		<div className={"p-2 flex flex-col gap-2"}>
			<h2 className={"text-xl"}>Créer un nouveau trajet</h2>
			<Card className={"grid grid-cols-2 items-center gap-2"}>
				<p>Nom</p>
				<Input value={name} onInput={e => setName(e.currentTarget.value)} placeholder={"Nom"}/>
				<p>Fichier</p>
				<FileInput placeholder={"Fichier"} accept={".geojson,.gpx"} value={journeyFile} setValue={setJourneyFile}/>
				{ user?.scope === EUserScope.Root &&
					<>
						<p>Association</p>
						<Select
							default={association}
							options={options ?? []}
							value={association}
							placeholder={"Association"}
							onChange={v => setAssociation(v as number)}
						/>
					</> }
				<Button
					disabled={name === "" || association === -1 || journeyFile === null}
					loading={loading}
					className={"col-span-2 justify-self-center"}
					onClick={() => {
						setLoading(true);
						createJourney();
					}}
				>
					Créer
				</Button>
			</Card>
		</div>
	);
}
