import { List } from "../../components/List/List.tsx";
import { TUser } from "../../types/TUser.ts";
import { Cell } from "../../components/List/Cell.tsx";
import {
	Link, useParams,
} from "react-router-dom";
import { useSideBar } from "../../sidebar/useSideBar.tsx";
import { api } from "../../utils/useApi.ts";
import { TAssociation } from "../../types/TAssociation.ts";
import {
	useEffect, useMemo,
} from "preact/hooks";
import { OpenInNew } from "@material-ui/icons";
import { equals } from "../../utils/equals.ts";

export function ListUser() {
	const {
		association, setAssociation,
	} = useSideBar();

	const { id } = useParams();

	useEffect(() => {
		if (id && !association) {
			api<TAssociation>(`/associations/${id}`).then((res) => {
				if (res.status === 200 && res.data !== null && res.data !== undefined) {
					if (!equals(res.data, association)) {
						setAssociation(res.data);
					}
				}
			});
		}
	}, [
		id,
		setAssociation,
		association,
	]);

	const filter = useMemo(() => {
		if (association === undefined) {
			return "";
		} else {
			return `id_association=eq:${association.id}`;
		}
	}, [association]);

	return (
		<List
			line={(u: TUser) => [
				<Cell>{ u.email }</Cell>,
				<Cell>{ u.username }</Cell>,
				<Cell>{ u.scope }</Cell>,
				<Cell>{ u.status }</Cell>,
				<Cell>{ new Date(u.last_login).toLocaleString() }</Cell>,
				<Cell><Link to={`/associations/${ u.association.id}`}>{ u.association.name }</Link></Cell>,
				<Cell><Link to={`/users/${u.id}`}><OpenInNew/></Link></Cell>,
			]}
			columns={[
				{
					name: "Mail",
					id: "email",
					width: "",
				},
				{
					name: "Pseudo",
					id: "username",
				},
				{
					name: "Role",
					id: "scope",
				},
				{
					name: "Statut",
					id: "status",
				},
				{
					name: "Dernière Connexion",
					id: "last_login",
				},
				{
					name: "Association",
					id: "associations",
				},
				{
					name: "",
					id: "",
				},
			]}
			baseUrl={"/users"} filter={filter}
		/>
	);
}
