import { Input } from "../components/Input/Input.tsx";
import { TextArea } from "../components/Input/TextArea.tsx";
import { InputCalendar } from "../components/Calendar/InputCalendar.tsx";
import { Button } from "../components/Button/Button.tsx";
import {
	api, useApi,
} from "../utils/useApi.ts";
import { TEvent } from "../types/TEvent.ts";
import { toast } from "react-toastify";
import { Card } from "../components/Card/Card.tsx";
import {
	Dispatch, StateUpdater, useEffect, useMemo, useState,
} from "preact/hooks";
import {
	Option, Select,
} from "../components/Select/Select.tsx";
import { useUser } from "../user/useUser.tsx";
import { EUserScope } from "../types/EUserScope.ts";
import { TList } from "../types/TList.ts";
import { TAssociation } from "../types/TAssociation.ts";

interface EventInfoProps {
	eventData: TEvent,
	setEventData: Dispatch<StateUpdater<TEvent>>,
	id: number
}

export function EventInfo(props: EventInfoProps) {
	const { user } = useUser();
	const [total, setTotal] = useState(20);
	const associations = useApi<TList<TAssociation>>(
		`/associations?per-page=${total}`,
		[total],
		{ if: user?.scope === EUserScope.Root },
	);
	const {
		eventData, setEventData, id,
	} = props;
	useEffect(() => {
		setTotal(associations.data?.total_data ?? 20);
	}, [associations, setTotal]);
	const options = useMemo(() => associations.data?.data?.map(a => ({
		value: a.id,
		name: a.name,
	} satisfies Option)), [associations]);

	const [association, setAssociation] = useState(-1);

	useEffect(() => {
		if (props.eventData.association) {
			setAssociation(props.eventData.association.id);
		}
	}, [props.eventData.association, setAssociation]);
	return (
		<Card className={"grid grid-cols-2 gap-2 items-center"}>
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
			{ user?.scope === EUserScope.Root &&
				<>
					<p>Association</p>
					<Select
						default={association}
						options={options ?? []}
						value={association}
						onChange={(v) => {
							setAssociation(parseInt(v?.toString() ?? association.toString()));
						}}
					/>
				</> }
			<Button
				className={"col-span-2 justify-self-center"}
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
		</Card>
	);
}
