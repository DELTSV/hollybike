import {
	Dispatch, StateUpdater, useCallback, useState,
} from "preact/hooks";
import { Modal } from "../components/Modal/Modal.tsx";
import { TUserPartial } from "../types/TUserPartial.ts";
import { List } from "../components/List/List.tsx";
import { Cell } from "../components/List/Cell.tsx";
import { CheckBox } from "../components/CheckBox.tsx";
import { Button } from "../components/Button/Button.tsx";
import { api } from "../utils/useApi.ts";
import { DoReload } from "../utils/useReload.ts";
import { toast } from "react-toastify";

interface ModalAddParticipantsProps {
	visible: boolean,
	setVisible: Dispatch<StateUpdater<boolean>>,
	eventId: number,
	doReload: DoReload
}

export function ModalAddParticipants(props: ModalAddParticipantsProps) {
	const [userIds, setUserIds] = useState<number[]>([]);
	const addCandidates = useCallback(() => {
		api(`/events/${props.eventId}/participations/add-users`, {
			method: "POST",
			body: { userIds: userIds },
		}).then((res) => {
			if (res.status === 200) {
				toast("Participants ajoutés", { type: "success" });
				props.doReload();
				props.setVisible(false);
				setUserIds([]);
			} else {
				toast(res.message, { type: "error" });
			}
		});
	}, [
		userIds,
		setUserIds,
		toast,
		props.doReload,
		props.setVisible,
	]);

	return (
		<Modal visible={props.visible} setVisible={props.setVisible}>
			<List
				action={<Button onClick={addCandidates}>Ajouter</Button>}
				columns={[
					{
						name: "Nom d'utlisateur",
						id: "username",
					},
					{
						name: "Rôle",
						id: "scope",
					},
					{
						name: "Fonction",
						id: "role",
					},
				]}
				baseUrl={`/events/${props.eventId}/participations/candidates`}
				line={(u: TUserPartial) => [
					<Cell>{ u.username }</Cell>,
					<Cell>{ u.scope }</Cell>,
					<Cell>{ u.role }</Cell>,
					<Cell>{ u.event_role === undefined ? <CheckBox
						checked={userIds.includes(u.id)}
						toggle={() => {
							let tmp = [...userIds];
							if (userIds.includes(u.id)) {
								tmp = tmp.filter(id => u.id !== id);
							} else {
								tmp.push(u.id);
							}
							setUserIds(tmp);
						}}
					/> : undefined }
					</Cell>,
				]}
			/>
		</Modal>
	);
}
