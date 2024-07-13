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
import { EventParticipant } from "./EventParticipants.tsx";
import { EventGallery } from "./EventGallery.tsx";
import { clsx } from "clsx";
import { EventExpense } from "./EventExpense.tsx";

export function EventDetail() {
	const {
		reload, doReload,
	} = useReload();
	const { id } = useParams();
	const event = useApi<TEvent>(`/events/${id}`, [reload]);
	const [eventData, setEventData] = useState<TEvent>(dummyEvent);
	const eventDetail = useApi<TEventDetail>(`/events/${id}/details`, [reload], { if: id !== undefined });

	useEffect(() => {
		if (event.status === 200 && event.data !== undefined) { setEventData(event.data); }
	}, [event, setEventData]);
	return (
		<div
			className={clsx(
				"grid grid-cols-1 gap-2 mx-2 w-full mb-2 overflow-y-auto overflow-x-hidden",
				"2xl:grid-flow-col 2xl:grid-cols-[700px_1fr] 2xl:grid-rows-2 max-h-[calc(100vh_-_88px)]",
			)}
		>
			<EventInfo eventData={eventData} setEventData={setEventData} id={parseInt(id ?? "-1")} doReload={doReload}/>
			<EventJourney eventDetail={eventDetail.data} doReload={doReload}/>
			<EventParticipant event={eventDetail.data?.event ?? dummyEvent}/>
			<div className={"flex gap-2 flex-col 2xl:flex-row"}>
				<EventGallery eventId={eventDetail.data?.event?.id ?? -1}/>
				<EventExpense
					expenses={eventDetail.data?.expenses ?? []}
					eventId={eventDetail?.data?.event?.id ?? -1}
					doReload={doReload}
				/>
			</div>
		</div>
	);
}
