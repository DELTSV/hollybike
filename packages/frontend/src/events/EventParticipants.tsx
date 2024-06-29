import { List } from "../components/List/List.tsx";
import { TEventParticipation } from "../types/TEventParticipation.ts";
import { Cell } from "../components/List/Cell.tsx";
import { dateTimeToFrenchString } from "../components/Calendar/InputCalendar.tsx";
import { OpenInNew } from "@material-ui/icons";

interface EventParticipantsProps {
	eventId: number
}

export function EventParticipant(props: EventParticipantsProps) {
	return (
		<List
			columns={[
				{
					name: "Nom d'utilisateur",
					id: "username",
				},
				{
					name: "Rôle",
					id: "role",
				},
				{
					name: "Rejoint le",
					id: "joined_date_time",
				},
				{
					name: "Image",
					id: "is_image_public",
				},
				{
					name: "Trajet",
					id: "journey",
				},
			]}
			baseUrl={`/events/${props.eventId}/participations`}
			line={(p: TEventParticipation) =>
				[
					<Cell>{ p.user.username }</Cell>,
					<Cell>{ p.role }</Cell>,
					<Cell>{ dateTimeToFrenchString(p.joinedDateTime, false) }</Cell>,
					<Cell>{ p.isImagePublic ? "Publiques" : "Privées" }</Cell>,
					<Cell>{ p.journey !== undefined ? <OpenInNew/> : undefined }</Cell>,
				]}
		/>
	);
}
