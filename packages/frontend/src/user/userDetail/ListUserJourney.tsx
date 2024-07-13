import { List } from "../../components/List/List.tsx";
import { TUserJourney } from "../../types/TUserJourney.ts";
import { useUser } from "../useUser.tsx";
import { Cell } from "../../components/List/Cell.tsx";
import { VisibilityOutlined } from "@material-ui/icons";
import { useNavigate } from "react-router-dom";
import { Card } from "../../components/Card/Card.tsx";

export function ListUserJourney() {
	const { user } = useUser();
	const navigate = useNavigate();
	return (
		<Card>
			<List
				if={user !== null}
				line={(uj: TUserJourney) => [
					<Cell>
						{ uj.total_elevation_gain }
					</Cell>,
					<Cell>
						{ uj.total_elevation_loss }
					</Cell>,
					<Cell>
						{ uj.total_distance }
					</Cell>,
					<Cell>
						{ uj.min_elevation }
					</Cell>,
					<Cell>
						{ uj.max_elevation }
					</Cell>,
					<Cell>
						{ uj.total_time }
					</Cell>,
					<Cell>
						{ uj.max_speed }
					</Cell>,
					<Cell>
						{ uj.min_elevation }
					</Cell>,
					<Cell>
						<VisibilityOutlined
							className={"cursor-pointer"} onClick={() => {
								navigate(`/user-journey/${uj.id}`);
							}}
						/>
					</Cell>,
				]}
				baseUrl={`/user-journeys/user/${user?.id}`}
				columns={[
					{
						name: "Dénivelé positif",
						id: "total_elevation_gain",
					},
					{
						name: "Dénivelé négatif",
						id: "total_elevation_loss",
					},
					{
						name: "Distance totale",
						id: "total_distance",
					},
					{
						name: "Altitude minimale",
						id: "min_elevation",
					},
					{
						name: "Altitude maximale",
						id: "max_elevation",
					},
					{
						name: "Temps total",
						id: "total_time",
					},
					{
						name: "Vitesse max",
						id: "max_speed",
					},
					{
						name: "Vitesse moyenne",
						id: "avg_speed",
					},
				]}
			/>
		</Card>
	);
}
