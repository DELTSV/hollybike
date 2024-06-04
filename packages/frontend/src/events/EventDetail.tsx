import { useParams } from "react-router-dom";
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";
import { useApi } from "../utils/useApi.ts";
import { TEvent } from "../types/TEvent.ts";

export function EventDetail() {
	const { id } = useParams();
	const event = useApi<TEvent>(`/events/${ id}`);
	return (
		<div className={"flex-col flex gap-2 mx-2"}>
			<Card className={"grid grid-cols-2"}>
				<p>Nom</p>
				<Input value={event.data?.name ?? ""}/>
			</Card>
		</div>
	);
}
