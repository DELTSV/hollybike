import { useParams } from "react-router-dom";
import { useApi } from "../utils/useApi.ts";
import {
	dummyEvent, TEvent,
} from "../types/TEvent.ts";
import {
	useEffect, useState,
} from "preact/hooks";
import { EventInfo } from "./EventInfo.tsx";
import { EventJourney } from "./EventJourney.tsx";
import { useReload } from "../utils/useReload.ts";
import { TEventDetail } from "../types/TEventDetail.ts";

export function EventDetail() {
	const {
		reload, doReload,
	} = useReload();
	const { id } = useParams();
	const event = useApi<TEvent>(`/events/${id}`);
	const [eventData, setEventData] = useState<TEvent>(dummyEvent);
	const eventDetail = useApi<TEventDetail>(`/events/${id}/details`, [reload]);

	useEffect(() => {
		if (event.status === 200 && event.data !== undefined) { setEventData(event.data); }
	}, [event, setEventData]);
	return (
		<div className={"grid grid-cols-[700px_1fr] grid-rows-2 gap-2 mx-2 w-full mb-2"}>
			<EventInfo eventData={eventData} setEventData={setEventData} id={parseInt(id ?? "-1")}/>
			<p/>
			<EventJourney eventDetail={eventDetail.data} doReload={doReload}/>
		</div>
	);
}
