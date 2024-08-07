/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Input } from "../components/Input/Input.tsx";
import { TextArea } from "../components/Input/TextArea.tsx";
import { InputCalendar } from "../components/Calendar/InputCalendar.tsx";
import { Button } from "../components/Button/Button.tsx";
import { api } from "../utils/useApi.ts";
import { TEvent } from "../types/TEvent.ts";
import { toast } from "react-toastify";
import { Card } from "../components/Card/Card.tsx";
import {
	Dispatch, StateUpdater, useEffect, useState,
} from "preact/hooks";
import { ButtonDanger } from "../components/Button/ButtonDanger.tsx";
import { useNavigate } from "react-router-dom";
import { EEventStatus } from "../types/EEventStatus.ts";
import { DoReload } from "../utils/useReload.ts";


interface EventInfoProps {
	eventData: TEvent,
	setEventData: Dispatch<StateUpdater<TEvent>>,
	id: number,
	doReload: DoReload
}

export function EventInfo(props: EventInfoProps) {
	const navigate = useNavigate();
	const [confirm, setConfirm] = useState(false);
	const {
		eventData, setEventData, id,
	} = props;
	const [budgetText, setBudgetText] = useState("");
	useEffect(() => {
		setBudgetText(eventData.budget ? (eventData.budget / 100).toFixed(2) : "");
	}, [eventData.budget]);
	return (
		<Card className={"grid grid-cols-2 gap-2 items-center 2xl:overflow-auto"}>
			<p>Nom</p>
			<Input
				value={eventData.name} onInput={e => setEventData(prev => ({
					...prev,
					name: e.currentTarget.value,
				}))}
			/>
			<p>Description</p>
			<TextArea
				value={eventData.description} onInput={e => setEventData(prev => (
					{
						...prev,
						description: e.currentTarget.value,
					}
				))}
			/>
			<p>Date de début</p>
			<InputCalendar
				value={eventData.start_date_time} setValue={(d) => {
					if (d !== undefined) {
						if (typeof d === "function") {
							setEventData(prev => ({
								...prev,
								start_date_time: d(prev.start_date_time)!,
							}));
						} else {
							setEventData(prev => ({
								...prev,
								start_date_time: d,
							}));
						}
					}
				}}
				time
			/>
			<p>Date de fin</p>
			<InputCalendar
				value={eventData.end_date_time} setValue={(d) => {
					if (typeof d === "function") {
						setEventData(prev => ({
							...prev,
							end_date_time: d(prev.end_date_time),
						}));
					} else {
						setEventData(prev => ({
							...prev,
							end_date_time: d,
						}));
					}
				}}
				time
			/>
			<p>Budget</p>
			<Input
				value={budgetText}
				type={"number"}
				onInput={e => setBudgetText(e.currentTarget.value)}
			/>
			<p>Statut</p>
			<EventStatus status={eventData.status} id={eventData.id} doReload={props.doReload}/>
			<Button
				className={"justify-self-center"}
				onClick={() => {
					api<TEvent>(`/events/${id}`, {
						method: "PUT",
						body: {
							name: eventData.name,
							description: eventData.description,
							start_date: eventData.start_date_time,
							end_date: eventData.end_date_time,
							budget: budgetText !== "" ? parseFloat(budgetText) * 100 : undefined,
						},
					}).then((res) => {
						if (res.status === 200 && res.data !== undefined) {
							setEventData(res.data);
							toast("Évènement mis à jour", { type: "success" });
						} else if (res.status === 404 || res.status === 400) {
							toast(res.message, { type: "warning" });
						}
					});
				}}
			>
				Sauvegarder
			</Button>
			<ButtonDanger
				className={"justify-self-center"}
				onClick={() => {
					if (confirm) {
						api(`/events/${eventData.id}`, { method: "DELETE" }).then((res) => {
							if (res.status === 200) {
								navigate("/events");
								toast("Évènement supprimé", { type: "success" });
							} else {
								toast(res.message, { type: "error" });
							}
						});
					} else {
						setConfirm(true);
						setTimeout(() => {
							setConfirm(false);
						}, 5000);
					}
				}}
			>
				{ confirm ? "Êtes vous sur ?" : "Supprimer l'évènement" }
			</ButtonDanger>
		</Card>
	);
}

interface EventStatusProps {
	status: EEventStatus,
	id: number,
	doReload: DoReload
}

function EventStatus(props: EventStatusProps) {
	if (props.status === EEventStatus.Pending) {
		return (
			<Button
				onClick={async () => {
					const resp = await api(`/events/${props.id}/schedule`, { method: "PATCH" });
					if (resp.status === 200) {
						toast("Évènement publié", { type: "success" });
						props.doReload();
					} else {
						toast(resp.message, { type: "error" });
					}
				}}
			>Publier
			</Button>
		);
	}
	if (props.status === EEventStatus.Scheduled) {
		return (
			<ButtonDanger
				onClick={async () => {
					const resp = await api(`/events/${props.id}/cancel`, { method: "PATCH" });
					if (resp.status === 200) {
						toast("Évènement annulé", { type: "warning" });
						props.doReload();
					} else {
						toast(resp.message, { type: "error" });
					}
				}}
			>Annuler
			</ButtonDanger>
		);
	}
	if (props.status === EEventStatus.Cancelled) {
		return (
			<Button
				onClick={async () => {
					const resp = await api(`/events/${props.id}/pend`, { method: "PATCH" });
					if (resp.status === 200) {
						toast("Évènement rétabli", { type: "success" });
						props.doReload();
					} else {
						toast(resp.message, { type: "error" });
					}
				}}
			>Rétablir
			</Button>
		);
	}

	if (props.status === EEventStatus.Now) {
		return <p>En cours</p>;
	}

	if (props.status === EEventStatus.Finished) {
		return <p>Terminé</p>;
	}

	return null;
}
