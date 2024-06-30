import { useSideBar } from "../sidebar/useSideBar.tsx";
import { TInvitation } from "../types/TInvitation.ts";
import { List } from "../components/List/List.tsx";
import { Cell } from "../components/List/Cell.tsx";
import { Button } from "../components/Button/Button.tsx";
import {
	Link, useNavigate, useParams,
} from "react-router-dom";
import {
	CheckCircleOutlineRounded, LinkOff, MailOutlineRounded,
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
import { Input } from "../components/Input/Input.tsx";
import { useUser } from "../user/useUser.tsx";
import { EUserScope } from "../types/EUserScope.ts";

export function ListInvitations() {
	const {
		association, setAssociation,
	} = useSideBar();

	const { user } = useUser();

	const { id } = useParams();

	useEffect(() => {
		if (id) {
			api<TAssociation>(`/associations/${id}`).then((res) => {
				if (res.status === 200 && res.data !== null && res.data !== undefined) { setAssociation(res.data); }
			});
		} else {
			setAssociation(undefined);
		}
	}, [id, setAssociation]);

	const {
		reload, doReload,
	} = useReload();

	const navigate = useNavigate();

	const url = useMemo(
		() =>
			id !== undefined ? `/associations/${association?.id}/invitations` : "/invitation"
		, [id, association],
	);

	const smtp = useApi("/smtp");

	const [qrCode, setQrCode] = useState("");

	const [modalQrCode, setModalQrCode] = useState(false);

	const [modalMail, setModalMail] = useState(false);

	const [mail, setMail] = useState("");
	const [invitation, setInvitation] = useState(-1);

	const filter = useMemo(() => {
		if (id !== undefined) { return `association=eq:${id}&status=neq:-1`; } else { return "status=neq:-1"; }
	}, [id]);

	return (
		<div className={"flex flex-col gap-2 w-full"}>
			<Button className={"mx-2 self-start"} onClick={() => navigate("/invitations/new")}>Créer une invitation</Button>
			<List
				reload={reload} filter={filter}
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
						visible: user?.scope === EUserScope.Root,
					},
					{
						name: "Lien",
						id: "link",
						width: "90px",
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
					<>
						{ user?.scope === EUserScope.Root &&
						<Cell>
							<Link to={`/associations/${i.association.id}`}>
								{ i.association.name }
							</Link>
						</Cell> }
					</>,
					<Cell className={"flex"}>
						{ i.link !== undefined &&
							<div className={"flex gap-2"}>
								<QRCodeScanner
									className={"cursor-pointer"}
									onClick={() => {
										setModalQrCode(true);
										setQrCode(i.link!);
									}}
								/>
								<LinkCell link={i.link}/>
								{ smtp.status === 200 && <MailOutlineRounded
									className={"cursor-pointer"} onClick={() => {
										setModalMail(true);
										setInvitation(i.id);
									}}
								/> }
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
									} else if (res.status === 404) {
										toast(res.message, { type: "warning" });
									} else {
										toast(res.message, { type: "error" });
									}
								});
							}}
						/> }
					</Cell>,
				]}
			/>
			<Modal title={"QR-Code d'invitation"} visible={modalQrCode} setVisible={setModalQrCode} width={"w-auto"}>
				<div className={"flex flex-col items-center justify-center m-4"}>
					<div className={"bg-white p-4 rounded"}>
						<QRCodeSVG bgColor={"transparent"} value={qrCode} height={"50vh"} width={"50vw"}/>
					</div>
				</div>
			</Modal>
			<Modal title={"Envoyer un mail"} visible={modalMail} setVisible={setModalMail} width={"w-auto"}>
				<form className={"flex flex-col items-center gap-2 p-4"} onSubmit={e => e.preventDefault()}>
					<Input placeholder={"Email"} value={mail} onInput={e => setMail(e.currentTarget.value)}/>
					<Button
						onClick={() => {
							api(`/invitation/${invitation}/send-mail`, {
								method: "POST",
								body: { dest: mail },
							}).then((res) => {
								if (res.status === 200) {
									toast("Mail envoyé avec success", { type: "success" });
									setMail("");
									setModalMail(false);
								} else {
									toast(`Erreur: ${res.message}`, { type: "error" });
									doReload();
								}
							});
						}}
					>
						Envoyer le mail
					</Button>
				</form>
			</Modal>
		</div>
	);
}

function LinkCell(props: {link: string}) {
	const input = useRef<HTMLInputElement>(null);

	const [copied, setCopied] = useState(false);
	return (
		<>
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
			<input className={"hidden"} value={props.link} ref={input}/>
		</>
	);
}
