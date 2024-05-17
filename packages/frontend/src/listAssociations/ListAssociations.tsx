import { useUser } from "../user/useUser.tsx";
import { useEffect } from "preact/hooks";
import { useNavigate } from "react-router-dom";
import { TAssociation } from "../types/TAssociation.ts";
import { List } from "../components/List/List.tsx";
import { Cell } from "../components/List/Cell.tsx";

export function ListAssociations() {
	const { user } = useUser();
	const navigate = useNavigate();

	useEffect(() => {
		if (user?.scope !== "Root")
			navigate("/");
	}, [user, navigate]);

	return (
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
			]}
			line={(d: TAssociation) => [
				<Cell>{ d.name }</Cell>,
				<Cell>{ d.status }</Cell>,
				<Cell>{ d.picture }</Cell>,
			]}
		/>
	);
}
