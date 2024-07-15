import { useUser } from "../../user/useUser.tsx";
import { useEffect } from "preact/hooks";
import { useNavigate } from "react-router-dom";
import { TAssociation } from "../../types/TAssociation.ts";
import { List } from "../../components/List/List.tsx";
import { Cell } from "../../components/List/Cell.tsx";
import { OpenInNew } from "@material-ui/icons";
import { Button } from "../../components/Button/Button.tsx";
import { useSideBar } from "../../sidebar/useSideBar.tsx";
import { Card } from "../../components/Card/Card.tsx";
import { EAssociationStatusToString } from "../../types/EAssociationStatus.ts";

export function ListAssociations() {
	const { user } = useUser();
	const navigate = useNavigate();
	const { setAssociation } = useSideBar();

	useEffect(() => {
		setAssociation(undefined);
	}, [setAssociation]);

	useEffect(() => {
		if (user?.scope !== "Root") {
			navigate("/");
		}
	}, [user, navigate]);

	return (
		<Card>
			<List
				action={
					<Button onClick={() => navigate("/associations/new")}>
						Créer une association
					</Button>
				}
				baseUrl={"/associations"} columns={[
					{
						name: "Nom",
						id: "name",
					},
					{
						name: "Statut",
						id: "status",
					},
					{
						name: "Image",
						id: "profile_picture",
					},
					{
						name: "",
						id: "",
					},
				]}
				line={(d: TAssociation) => [
					<Cell>{ d.name }</Cell>,
					<Cell>{ EAssociationStatusToString(d.status) }</Cell>,
					<Cell>
						{ d.picture !== undefined ?
							<img className={"max-h-10"} src={d.picture} alt={`Image de l'association ${d.name}`}/> :
							<p>Aucune image</p> }
					</Cell>,
					<Cell
						className={"cursor-pointer"}
						  onClick={() => navigate(`/associations/${d.id}`)}
					><OpenInNew/>
					</Cell>,
				]}
			/>
		</Card>
	);
}
