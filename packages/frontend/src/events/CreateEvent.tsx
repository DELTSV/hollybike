import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";
import { InputCalendar } from "../components/Calendar/InputCalendar.tsx";
import { Button } from "../components/Button/Button.tsx";
import {
	useEffect, useState,
} from "preact/hooks";
import {
	api, useApi,
} from "../utils/useApi.ts";
import { toast } from "react-toastify";
import { useNavigate } from "react-router-dom";
import { TEvent } from "../types/TEvent.ts";
import { useUser } from "../user/useUser.tsx";
import { EUserScope } from "../types/EUserScope.ts";
import { Select } from "../components/Select/Select.tsx";
import { TList } from "../types/TList.ts";
import { TAssociation } from "../types/TAssociation.ts";
import { TextArea } from "../components/Input/TextArea.tsx";

export function CreateEvent() {
	const navigate = useNavigate();
	const { user } = useUser();
	const [name, setName] = useState("");
	const [description, setDescription] = useState("");
	const [start, setStart] = useState<Date>();
	const [end, setEnd] = useState<Date>();
	const [association, setAssociation] = useState<number>();

	const [total, setTotal] = useState(20);

	const associations = useApi<TList<TAssociation>>(`/associations?per_page=${total}`);

	useEffect(() => {
		if (associations.data?.total_data !== undefined)
			setTotal(associations.data?.total_data);
	}, [associations.data?.total_data]);

	useEffect(() => {
		if (start === undefined) {
			const now = new Date();
			now.setMinutes(0);
			now.setSeconds(0);
			now.setHours(now.getHours() + 1);
			setStart(now);
		}
	}, [setStart]);
	return (
		<div className={"mx-2"}>
			<Card>
				<h2 className={"text-xl"}>Créer un événement</h2>
				<form className={"grid grid-cols-2 items-center gap-2"} onSubmit={e => e.preventDefault()}>
					<p>Nom de l'événement</p>
					<Input value={name} onInput={e => setName(e.currentTarget.value)} placeholder={"Nom"}/>
					<p>Description</p>
					<TextArea value={description} onInput={e => setDescription(e.currentTarget.value)}></TextArea>
					<p>Date de début</p>
					<InputCalendar value={start} setValue={setStart} time/>
					<p>Date de fin</p>
					<InputCalendar value={end} setValue={setEnd} time/>
					{ user?.scope === EUserScope.Root &&
						<>
							<p>Association</p>
							<Select
								value={association} onChange={value => setAssociation(value as number)}
								searchable={total > 5}
								options={associations.data?.data?.map(a => ({
									name: a.name,
									value: a.id,
								})) ?? []}
							/>
						</> }
					<Button
						type={"submit"}
						className={"col-span-2 justify-self-center"} onClick={() => {
							api<TEvent>("/events", {
								method: "POST",
								body: {
									name: name,
									description: description,
									start_date: start?.toISOString(),
									end_date: end?.toISOString(),
									association: user?.scope === EUserScope.Root ? association : undefined,
								},
							}).then((res) => {
								if (res.status === 201 && res.data !== undefined) {
									toast("Événements créer", { type: "success" });
									navigate(`/events/${res.data.id}`);
								} else if (res.status === 400)
									toast(res.message, { type: "warning" });
								 else
									toast(`Erreur: ${ res.message}`, { type: "error" });
							});
						}}
					>
						Créer
					</Button>
				</form>
			</Card>
		</div>
	);
}
