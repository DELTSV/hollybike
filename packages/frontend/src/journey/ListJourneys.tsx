import { Button } from "../components/Button/Button.tsx";
import {
	Link, useParams,
} from "react-router-dom";
import { useEffect } from "preact/hooks";
import { useSideBar } from "../sidebar/useSideBar.tsx";
import { api } from "../utils/useApi.ts";
import { TAssociation } from "../types/TAssociation.ts";
import { List } from "../components/List/List.tsx";
import { Cell } from "../components/List/Cell.tsx";
import { timeToFrenchString } from "../components/Calendar/InputCalendar.tsx";
import { TJourney } from "../types/TJourney.ts";
import { Download } from "../icons/Download.tsx";
import {
	DeleteOutlined, VisibilityOutlined,
} from "@material-ui/icons";
import { toast } from "react-toastify";
import { useReload } from "../utils/useReload.ts";

export function ListJourneys() {
	const { id } = useParams();
	const {
		reload, doReload,
	} = useReload();

	const {
		association, setAssociation,
	} = useSideBar();

	useEffect(() => {
		if (id !== undefined && parseInt(id) !== association?.id) {
			api<TAssociation>(`/associations/${id}`, { if: !isNaN(parseInt(id)) }).then((res) => {
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

	return (
		<div className={"w-full flex flex-col gap-2 mx-2"}>
			<Link to={"/journeys/new"}>
				<Button className={"self-start"} onClick={() => {}}>
					Importer un trajet
				</Button>
			</Link>
			<List
				reload={reload}
				columns={[
					{
						name: "Nom",
						id: "journey_name",
					},
					{
						name: "Date de création",
						id: "created_at",
					},
					{
						name: "Createur",
						id: "username",
					},
					{
						name: "Association",
						id: "name",
					},
					{
						name: "Télécharger",
						id: "",
						width: "32px",
					},
					{
						name: "Voir",
						id: "",
						width: "24px",
					},
					{
						name: "Suppr.",
						id: "",
						width: "24px",
					},
				]}
				line={(j: TJourney) => [
					<Cell>
						{ j.name }
					</Cell>,
					<Cell>
						{ timeToFrenchString(j.created_at, true) }
					</Cell>,
					<Cell>
						<Link to={`/users/${j.creator.id}`}>
							{ j.creator.username }
						</Link>
					</Cell>,
					<Cell>
						<Link to={`/associations/${j.association.id}`}>
							{ j.association.name }
						</Link>
					</Cell>,
					<Cell className={"flex justify-center"}>
						{ j.file &&
							<a href={j.file} target={"_blank"}>
								<Download/>
							</a> }
					</Cell>,
					<Cell>
						{ j.file &&
							<Link to={`/journeys/view/${ j.id}`}>
								<VisibilityOutlined/>
							</Link> }
					</Cell>,
					<Cell>
						<DeleteOutlined
							className={"cursor-pointer"} onClick={() => {
								api(`/journeys/${j.id}`, { method: "DELETE" }).then((res) => {
									if (res.status === 204) {
										toast("Trajet supprimé", { type: "success" });
										doReload();
									} else if (res.status === 404) {
										toast(res.message, { type: "warning" });
										doReload();
									} else {
										toast(res.message, { type: "error" });
									}
								});
							}}
						/>
					</Cell>,
				]}
				baseUrl={"/journeys"}
			/>
		</div>
	);
}
