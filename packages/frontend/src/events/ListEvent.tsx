import { List } from "../components/List/List.tsx";
import {
	Link,
	useNavigate, useParams,
} from "react-router-dom";
import { Cell } from "../components/List/Cell.tsx";
import { TEvent } from "../types/TEvent.ts";
import { Button } from "../components/Button/Button.tsx";
import { OpenInNew } from "@material-ui/icons";
import { dateTimeToFrenchString } from "../components/Calendar/InputCalendar.tsx";

export function ListEvent() {
	const { id } = useParams();
	const navigate = useNavigate();
	return (
		<div className={"mx-2 gap-2 flex flex-col items-start"}>
			<Button onClick={() => navigate("/events/new")}>
				Créer un événement
			</Button>
			<List
				columns={[
					{
						name: "Nom",
						id: "name",
					},
					{
						name: "Description",
						id: "description",
					},
					{
						name: "Début",
						id: "start_date_time",
					},
					{
						name: "Fin",
						id: "end_date_time",
					},
					{
						name: "Statut",
						id: "status",
					},
					{
						name: "Créateur",
						id: "owner",
					},
					{
						name: "Création",
						id: "create_date_time",
					},
					{
						name: "Association",
						id: "association",
						visible: id === undefined,
					},
					{
						name: "",
						id: "",
					},
				]}
				baseUrl={"/events"} line={(e: TEvent) => [
					<Cell>
						{ e.name }
					</Cell>,
					<Cell>
						{ e.description }
					</Cell>,
					<Cell>
						{ dateTimeToFrenchString(e.start_date_time, false) }
					</Cell>,
					<Cell>
						{ e.end_date_time ? dateTimeToFrenchString(e.end_date_time, false) : "Jamais" }
					</Cell>,
					<Cell>
						{ e.status }
					</Cell>,
					<Cell>
						<Link to={`/users/${e.owner.id}`}>
							{ e.owner.username }
						</Link>
					</Cell>,
					<Cell>
						{ dateTimeToFrenchString(e.create_date_time, false) }
					</Cell>,
					<Cell>
						<Link to={`/associations${ e.association.id}`}>
							{ e.association.name }
						</Link>
					</Cell>,
					<Cell className={"cursor-pointer"} onClick={() => navigate(`/events/${e.id}`)}>
						<OpenInNew/>
					</Cell>,
				]}
			/>
		</div>
	);
}
