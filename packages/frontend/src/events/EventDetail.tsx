import { useParams } from "react-router-dom";
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";
import {
	api, useApi,
} from "../utils/useApi.ts";
import {
	dummyEvent, TEvent,
} from "../types/TEvent.ts";
import {
	useEffect, useState,
} from "preact/hooks";
import { TextArea } from "../components/Input/TextArea.tsx";
import { InputCalendar } from "../components/Calendar/InputCalendar.tsx";
import { Button } from "../components/Button/Button.tsx";
import { toast } from "react-toastify";

export function EventDetail() {
	const { id } = useParams();
	const event = useApi<TEvent>(`/events/${ id}`);
	const [eventData, setEventData] = useState<TEvent>(dummyEvent);

	useEffect(() => {
		if (event.status === 200 && event.data !== undefined)
			setEventData(event.data);
	}, [event, setEventData]);
	return (
		<div className={"flex-col flex gap-2 mx-2"}>
			<Card className={"grid grid-cols-2 gap-2"}>
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
						if (d !== undefined)
							if (typeof d === "function")
								setEventData(prev => ({
									...prev,
									start_date_time: d(prev.start_date_time)!,
								}));
							 else
								setEventData(prev => ({
									...prev,
									start_date_time: d,
								}));
					}}
				/>
				<p>Date de fin</p>
				<InputCalendar
					value={eventData.end_date_time} setValue={(d) => {
						if (typeof d === "function")
							setEventData(prev => ({
								...prev,
								end_date_time: d(prev.end_date_time),
							}));
						else
							setEventData(prev => ({
								...prev,
								end_date_time: d,
							}));
					}}
				/>
				<Button
					onClick={() => {
						api<TEvent>(`/events/${id}`, {
							method: "PUT",
							body: {
								name: eventData.name,
								description: eventData.description,
								start_date: eventData.start_date_time,
								end_date: eventData.end_date_time,
							},
						}).then((res) => {
							if (res.status === 200 && res.data !== undefined)
								setEventData(res.data);
							else if (res.status === 404 || res.status === 400)
								toast(res.message, { type: "warning" });
						});
					}}
				>
					Sauvegarder
				</Button>
			</Card>
		</div>
	);
}
