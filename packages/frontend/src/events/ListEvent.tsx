import {List} from "../components/List/List.tsx";
import {
	Link, useNavigate, useParams,
} from "react-router-dom";
import {Cell} from "../components/List/Cell.tsx";
import {TEvent} from "../types/TEvent.ts";
import {Button} from "../components/Button/Button.tsx";
import {OpenInNew} from "@material-ui/icons";
import {dateTimeToFrenchString} from "../components/Calendar/InputCalendar.tsx";
import {
	useEffect, useMemo,
} from "preact/hooks";
import {useSideBar} from "../sidebar/useSideBar.tsx";
import {api} from "../utils/useApi.ts";
import {TAssociation} from "../types/TAssociation.ts";
import {useUser} from "../user/useUser.tsx";
import {EUserScope} from "../types/EUserScope.ts";
import {Card} from "../components/Card/Card.tsx";

export function ListEvent() {
	const {id} = useParams();
	const {
		association, setAssociation,
	} = useSideBar();
	const navigate = useNavigate();
	const {user} = useUser();

	useEffect(() => {
		if (id && !association) {
			api<TAssociation>(`/associations/${id}`).then((res) => {
				if (res.status === 200 && res.data !== undefined) {
					setAssociation(res.data);
				}
			});
		}
	}, [
		id,
		setAssociation,
		association,
	]);

	const filter = useMemo(() => {
		if (id === undefined) {
			return "";
		} else {
			return `id_association=eq:${association?.id}`;
		}
	}, [association]);

	return (
		<Card>
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
						visible: user?.scope === EUserScope.Root,
					},
					{
						name: "",
						id: "",
					},
				]} filter={filter}
				baseUrl={"/events"} line={(e: TEvent) => [
				<Cell>
					{e.name}
				</Cell>,
				<Cell>
					{e.description}
				</Cell>,
				<Cell>
					{dateTimeToFrenchString(e.start_date_time, false)}
				</Cell>,
				<Cell>
					{e.end_date_time ? dateTimeToFrenchString(e.end_date_time, false) : "Jamais"}
				</Cell>,
				<Cell>
					{e.status}
				</Cell>,
				<Cell>
					<Link to={`/users/${e.owner.id}`}>
						{e.owner.username}
					</Link>
				</Cell>,
				<Cell>
					{dateTimeToFrenchString(e.create_date_time, false)}
				</Cell>,
				<>
					{user?.scope === EUserScope.Root &&
                        <Cell>
                            <Link to={`/associations/${e.association.id}`}>
								{e.association.name}
                            </Link>
                        </Cell>}
				</>,
				<Cell className={"cursor-pointer"} onClick={() => navigate(`/events/${e.id}`)}>
					<OpenInNew/>
				</Cell>,
			]}
				action={
					<Button onClick={() => navigate("/events/new")}>
						Créer un événement
					</Button>
				}
			/>
		</Card>
	);
}
