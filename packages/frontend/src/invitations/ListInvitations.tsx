import { useSideBar } from "../sidebar/useSideBar.tsx";
import { TInvitation } from "../types/TInvitation.ts";
import { List } from "../components/List/List.tsx";
import { Cell } from "../components/List/Cell.tsx";
import { Button } from "../components/Button/Button.tsx";
import {
	Link,
	useNavigate, useParams,
} from "react-router-dom";
import {
	CheckCircleOutlineRounded,
	LinkOff, MailOutlineRounded,
} from "@material-ui/icons";
import {
	api, useApi,
} from "../utils/useApi.ts";
import { useReload } from "../utils/useReload.ts";
import {
	useEffect, useMemo, useState,
} from "preact/hooks";
import { TAssociation } from "../types/TAssociation.ts";
import { toast } from "react-toastify";
import {
	dateToFrenchString, timeToFrenchString,
} from "../components/Calendar/InputCalendar.tsx";
import { QRCodeScanner } from "../icons/QRCodeScanner.tsx";
import { ContentCopy } from "../icons/ContentCopy.tsx";
import { Modal } from "../components/Modal/Modal.tsx";
import { QRCodeSVG } from "qrcode.react";
import { useRef } from "react";

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

	const url = useMemo(
		() =>
			id !== undefined ? `/associations/${association?.id}/invitations` : "/invitation"
		, [],
	);

	const smtp = useApi("/smtp");

	const [qrCode, setQrCode] = useState("");

	const [modalQrCode, setmodalQrCode] = useState(false);

	const input = useRef<HTMLInputElement>(null);

	const [copied, setCopied] = useState(false);

	return (
		<div className={"flex flex-col gap-2"}>
			<Button className={"mx-2 self-start"} onClick={() => navigate("/invitations/new")}>Créer une invitation</Button>
			<List
				reload={reload} filter={association !== undefined ? `association=eq:${association.id}` : ""}
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
						name: "Association",
						id: "association",
						visible: id === undefined,
					},
					{
						name: "Lien",
						id: "link",
					},
					{
						name: "Désactiver",
						id: "",
						width: "150px",
					},
				]}
				baseUrl={url} line={(i: TInvitation) => [
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
						{ i.expiration !== null ? `${dateToFrenchString(new Date(i.expiration))} ` +
							`${ timeToFrenchString(new Date(i.expiration), true)}` : "Jamais" }
					</Cell>,
					<Cell>
						<Link to={`/associations/${ i.association.id}`}>
							{ i.association.name }
						</Link>
					</Cell>,
					<Cell className={"flex"}>
						{ i.link !== undefined &&
							<div className={"flex gap-2"}>
								<QRCodeScanner
									className={"cursor-pointer"}
									onClick={() => {
										setmodalQrCode(true);
										setQrCode(i.link!);
									}}
								/>
								{ copied ?
									<CheckCircleOutlineRounded className={"cursor-pointer text-green"}/>:
									<ContentCopy
										className={"cursor-pointer"}
										onClick={() => {
											if (input.current) {
												input.current.select();
												input.current.setSelectionRange(0, 999999);
												navigator.clipboard.writeText(input.current.value).then(() => {
													toast("Lien copié", { type: "success" });
													setCopied(true);
													setTimeout(() => {
														setCopied(false);
													}, 1500);
												});
											}
										}}
									/> }
								<input className={"hidden"} value={i.link} ref={input}/>
								{ smtp.status === 200 && <MailOutlineRounded/> }
							</div> }
					</Cell>,
					<Cell>
						{ i.status === "Enabled" &&
						<LinkOff
							className={"cursor-pointer"} onClick={() => {
								api(`/invitation/${i.id}/disable`, { method: "PATCH" }).then((res) => {
									if (res.status === 200) {
										toast("Invitation désactivée", { type: "success" });
										doReload();
									} else if (res.status === 404)
										toast(res.message, { type: "warning" });
									else
										toast(res.message, { type: "error" });
								});
							}}
						/> }
					</Cell>,
				]}
			/>
			<Modal title={"QR-Code d'invitation"} visible={modalQrCode} setVisible={setmodalQrCode} width={"w-auto"}>
				<div className={"flex justify-center m-4"}>
					<QRCodeSVG value={qrCode} height={"50vh"} width={"50vw"}/>
				</div>
			</Modal>
		</div>
	);
}
