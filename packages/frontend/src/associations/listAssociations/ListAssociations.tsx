import { useUser } from "../../user/useUser.tsx";
import { useEffect } from "preact/hooks";
import { useNavigate } from "react-router-dom";
import { TAssociation } from "../../types/TAssociation.ts";
import { List } from "../../components/List/List.tsx";
import { Cell } from "../../components/List/Cell.tsx";
import { OpenInNew } from "@material-ui/icons";
import { Button } from "../../components/Button/Button.tsx";

export function ListAssociations() {
	const { user } = useUser();
	const navigate = useNavigate();

	useEffect(() => {
		if (user?.scope !== "Root")
			navigate("/");
	}, [user, navigate]);

	return (
		<div className={"flex flex-col gap-2 w-full"}>
			<Button className={"mx-2 self-start"} onClick={() => navigate("/associations/new")}>
				Créer une association
			</Button>
			<List
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
					<Cell>{ d.status }</Cell>,
					<Cell>{ d.picture }</Cell>,
					<Cell className={"cursor-pointer"} onClick={() => navigate(`/associations/${d.id}`)}><OpenInNew/></Cell>,
				]}
			/>
		</div>
	);
}
