import { List } from "../components/List/List.tsx";
import { TEventParticipation } from "../types/TEventParticipation.ts";
import { Cell } from "../components/List/Cell.tsx";
import { dateTimeToFrenchString } from "../components/Calendar/InputCalendar.tsx";
import {
	ArrowDownwardOutlined,
	ArrowUpwardOutlined, DeleteOutlined, OpenInNew, StarOutline,
} from "@material-ui/icons";
import { Button } from "../components/Button/Button.tsx";
import { TEvent } from "../types/TEvent.ts";
import { EEventRole } from "../types/EEventRole.ts";
import {
	useCallback, useState,
} from "preact/hooks";
import { api } from "../utils/useApi.ts";
import { toast } from "react-toastify";
import {
	DoReload, useReload,
} from "../utils/useReload.ts";
import { ModalAddParticipants } from "./ModalAddParticipants.tsx";
import { Link } from "react-router-dom";
import { Card } from "../components/Card/Card.tsx";

interface EventParticipantsProps {
	event: TEvent
}

export function EventParticipant(props: EventParticipantsProps) {
	const {
		reload, doReload,
	} = useReload();
	const [visible, setVisible] = useState(false);
	const removeParticipant = useCallback((userId: number) => {
		api(`/events/${props.event.id}/participations/${userId}`, { method: "DELETE" }).then((res) => {
			if (res.status === 200) {
				toast("Participant supprimé", { type: "success" });
				doReload();
			} else {
				toast(res.message, { type: "error" });
			}
		});
	}, [
		props.event.id,
		toast,
		doReload,
	]);
	return (
		<Card>
			<List
				action={<Button onClick={() => setVisible(true)}>Ajouter des participants</Button>}
				columns={[
					{
						name: "",
						id: "",
					},
					{
						name: "Nom d'utilisateur",
						id: "username",
					},
					{
						name: "Rôle",
						id: "role",
					},
					{
						name: "Rejoint le",
						id: "joined_date_time",
					},
					{
						name: "Image",
						id: "is_image_public",
					},
					{
						name: "Trajet",
						id: "journey",
					},
					{
						name: "",
						id: "",
					},
				]}
				reload={reload}
				baseUrl={`/events/${props.event.id}/participations`}
				line={(p: TEventParticipation) =>
					[
						<Cell>{ p.user.id === props.event.owner.id ? <StarOutline/> : undefined }</Cell>,
						<Cell>{ p.user.username }</Cell>,
						<Cell><EventRole role={p.role} eventId={props.event.id} userId={p.user.id} doReload={doReload}/></Cell>,
						<Cell>{ dateTimeToFrenchString(p.joinedDateTime, false) }</Cell>,
						<Cell>{ p.isImagePublic ? "Publiques" : "Privées" }</Cell>,
						<Cell>
							{ p.journey !== undefined ?
								<Link to={`/user-journey/${p.journey.id}`}><OpenInNew/></Link> :
								undefined }
						</Cell>,
						<Cell>
							{ p.user.id !== props.event.owner.id ?
								<DeleteOutlined className={"cursor-pointer"} onClick={() => removeParticipant(p.user.id)}/> :
								undefined }
						</Cell>,
					]}
			/>
			<ModalAddParticipants visible={visible} setVisible={setVisible} eventId={props.event.id} doReload={doReload}/>
		</Card>
	);
}

interface EventRoleProps {
	role: EEventRole,
	eventId: number,
	userId: number,
	doReload: DoReload
}

function EventRole(props: EventRoleProps) {
	const demote = useCallback(() => {
		api(`/events/${props.eventId}/participations/${props.userId}/demote`, { method: "PATCH" }).then((res) => {
			if (res.status === 200) {
				toast("Participation mise à jour", { type: "success" });
				props.doReload();
			} else if (res.status === 403 && res.message === "Vous ne pouvez pas vous rétrograder") {
				toast(res.message, { type: "warning" });
			} else {
				toast(res.message, { type: "error" });
			}
		});
	}, [
		props.doReload,
		props.eventId,
		props.userId,
	]);

	const promote = useCallback(() => {
		api(`/events/${props.eventId}/participations/${props.userId}/promote`, { method: "PATCH" }).then((res) => {
			if (res.status === 200) {
				toast("Participation mise à jour", { type: "success" });
				props.doReload();
			} else {
				toast(res.message, { type: "error" });
			}
		});
	}, [
		props.doReload,
		props.eventId,
		props.userId,
	]);

	if (props.role === EEventRole.Member) {
		return (
			<div className={"flex justify-center cursor-pointer"} onClick={promote}>
				<p>Membre</p>
				<ArrowUpwardOutlined/>
			</div>
		);
	} else {
		return (
			<div className={"flex justify-center cursor-pointer"} onClick={demote}>
				<p>Organisateur</p>
				<ArrowDownwardOutlined/>
			</div>
		);
	}
}
