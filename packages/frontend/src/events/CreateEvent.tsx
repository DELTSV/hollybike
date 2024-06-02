import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";
import { InputCalendar } from "../components/Calendar/InputCalendar.tsx";
import { Button } from "../components/Button/Button.tsx";
import {
	useEffect, useState,
} from "preact/hooks";
import { api } from "../utils/useApi.ts";
import { toast } from "react-toastify";
import { useNavigate } from "react-router-dom";
import { TEvent } from "../types/TEvent.ts";

export function CreateEvent() {
	const navigate = useNavigate();
	const [name, setName] = useState("");
	const [description, setDesciption] = useState("");
	const [start, setStart] = useState<Date>();

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
					<textarea value={description} onInput={e => setDesciption(e.currentTarget.value)}></textarea>
					<p>Date de début</p>
					<InputCalendar value={start} setValue={setStart} time/>
					<p>Date de fin</p>
					<InputCalendar/>
					<Button
						type={"submit"}
						className={"col-span-2 justify-self-center"} onClick={() => {
							api<TEvent>("/events", {
								method: "POST",
								body: {
									name: name,
									description: description,
									start_date: start?.toISOString(),
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
