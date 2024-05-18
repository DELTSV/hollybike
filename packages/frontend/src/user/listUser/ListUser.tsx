import { List } from "../../components/List/List.tsx";
import { TUser } from "../../types/TUser.ts";
import { Cell } from "../../components/List/Cell.tsx";
import { Link } from "react-router-dom";

export function ListUser() {
	return (
		<List
			line={(u: TUser) => [
				<Cell>{ u.email }</Cell>,
				<Cell>{ u.username }</Cell>,
				<Cell>{ u.scope }</Cell>,
				<Cell>{ u.status }</Cell>,
				<Cell>{ new Date(u.last_login).toLocaleString() }</Cell>,
				<Cell><Link to={`/associations/${ u.association.id}`}>{ u.association.name }</Link></Cell>,
			]}
			columns={[
				{
					name: "Mail",
					id: "email",
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
			]}
			baseUrl={"/users"}
		/>
	);
}
