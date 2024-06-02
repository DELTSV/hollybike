import { List } from "../components/List/List.tsx";
import {
	useNavigate, useParams,
} from "react-router-dom";
import { Cell } from "../components/List/Cell.tsx";
import { TEvent } from "../types/TEvent.ts";
import { Button } from "../components/Button/Button.tsx";

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
						name: "Test",
						id: "test",
					},
					{
						name: "Association",
						id: "association",
						visible: id === undefined,
					},
				]}
				baseUrl={"/events"} line={(e: TEvent) => [
					<Cell>
						{ e.name }
					</Cell>,
					<Cell>
						À rajouter
					</Cell>,
				]}
			/>
		</div>
	);
}
