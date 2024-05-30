import { useSideBar } from "../sidebar/useSideBar.tsx";
import { TInvitation } from "../types/TInvitation.ts";
import { List } from "../components/List/List.tsx";
import { Cell } from "../components/List/Cell.tsx";
import { Button } from "../components/Button/Button.tsx";
import {
	useNavigate, useParams,
} from "react-router-dom";
import { LinkOff } from "@material-ui/icons";
import { api } from "../utils/useApi.ts";
import { useReload } from "../utils/useReload.ts";
import { useEffect } from "preact/hooks";
import { TAssociation } from "../types/TAssociation.ts";

export function ListInvitations() {
	const {
		association, setAssociation,
	} = useSideBar();

	const { id } = useParams();

	useEffect(() => {
		if (id)
			api<TAssociation>(`/associations/${id}`).then((res) => {
				if (res.status === 200 && res.data !== null && res.data !== undefined)
					setAssociation(res.data);
			});
	}, [id, setAssociation]);

	const {
		reload, doReload,
	} = useReload();

	const navigate = useNavigate();

	return (
		<div className={"flex flex-col gap-2"}>
			<Button className={"mx-2 self-start"} onClick={() => navigate("/invitations/new")}>Créer une invitation</Button>
			<List
				reload={reload}
				columns={[
					{
						name: "Rôle",
						id: "name",
					},
					{
						name: "Utilisations",
						id: "uses",
					},
					{
						name: "Utilisations max",
						id: "max_uses",
					},
					{
						name: "Expiration",
						id: "expiration",
					},
					{
						name: "Lien",
						id: "link",
					},
					{
						name: "Désactiver",
						id: "",
					},
				]}
				baseUrl={`/associations/${association?.id}/invitations`} line={(i: TInvitation) => [
					<Cell>
						{ i.role }
					</Cell>,
					<Cell>
						{ i.uses }
					</Cell>,
					<Cell>
						{ i.max_uses !== null ? i.max_uses : "Infini" }
					</Cell>,
					<Cell>
						{ i.expiration !== null ? i.expiration : "Jamais" }
					</Cell>,
					<Cell>
						<a>{ i.link }</a>
					</Cell>,
					<Cell>
						{ i.status === "Enabled" &&
						<LinkOff
							className={"cursor-pointer"} onClick={() => {
								api(`/invitation/${i.id}/disable`, { method: "PATCH" }).then((res) => {
									if (res.status === 200)
										doReload();
								});
							}}
						/> }
					</Cell>,
				]}
			/>
		</div>
	);
}
