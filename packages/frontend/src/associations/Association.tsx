/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	useNavigate, useParams,
} from "react-router-dom";
import {
	api, apiRaw, useApi,
} from "../utils/useApi.ts";
import {
	dummyAssociation, TAssociation,
} from "../types/TAssociation.ts";
import { useSideBar } from "../sidebar/useSideBar.tsx";
import {
	useEffect, useState,
} from "preact/hooks";
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";
import { Select } from "../components/Select/Select.tsx";
import { Button } from "../components/Button/Button.tsx";
import { useUser } from "../user/useUser.tsx";
import { toast } from "react-toastify";
import { FileInput } from "../components/Input/FileInput.tsx";
import { useReload } from "../utils/useReload.ts";
import { AssociationData } from "./AssociationData.tsx";
import { Report } from "./Report.tsx";
import { ButtonDanger } from "../components/Button/ButtonDanger.tsx";
import { Modal } from "../components/Modal/Modal.tsx";
import { EUserScope } from "../types/EUserScope.ts";
import {
	EAssociationStatus, EAssociationStatusOptions,
} from "../types/EAssociationStatus.ts";

export function Association() {
	const { user } = useUser();

	const { id } = useParams();

	const {
		reload, doReload,
	} = useReload();

	const association = useApi<TAssociation>(`/associations/${id}`, [reload]);

	const [associationData, setAssociationData] = useState(dummyAssociation);

	const { setAssociation } = useSideBar();

	const [file, setFile] = useState<File|null>(null);

	const [visible, setVisible] = useState(false);

	const navigate = useNavigate();

	useEffect(() => {
		if (association.data) {
			setAssociation(association.data);
			setAssociationData(association.data);
		}
	}, [association, setAssociation]);
	return (
		<div className={"w-full grid grid-cols-2 gap-2"}>
			<Card>
				<form className={"grid grid-cols-2 gap-2 items-center"} onSubmit={e => e.preventDefault()}>
					<p>Nom de l'association :</p>
					<Input
						value={associationData?.name} onInput={(e) => {
							setAssociationData(prev => ({
								...prev,
								name: e.currentTarget.value,
							}));
						}}
					/>
					<p>Statut :</p>
					<Select
						disabled={user?.scope !== EUserScope.Root}
						value={associationData?.status}
						options={EAssociationStatusOptions}
						default={associationData?.status}
						onChange={v => setAssociationData(prev => ({
							...prev,
							status: v as EAssociationStatus,
						}))}
					/>
					<p>Nouvelle image:</p>
					<FileInput value={file} setValue={setFile} placeholder={"Nouvelle image"}/>
					<p>Image :</p>
					{ associationData.picture ?
						<img className={"max-h-40"} alt={"Logo de l'association"} src={association.data?.picture}/> :
						"Aucune image" }
					<Button
						type={"submit"}
						className={"justify-self-center col-span-2"}
						onClick={() => {
							const url = user?.scope !== EUserScope.Root ? "/associations/me" : `/associations/${associationData.id}`;
							api<TAssociation>(url, {
								method: "PATCH",
								body: associationData,
							}).then((res) => {
								if (res.status === 200 && res.data) {
									setAssociationData(res.data);
									if (file !== null) {
										const fd = new FormData();
										fd.append("file", file);
										apiRaw("/associations/me/picture", undefined, {
											method: "PATCH",
											body: fd,
										}).then((res) => {
											if (res.status === 200) {
												toast("Association mise à jour", { type: "success" });
												doReload();
											} else {
												toast(`Erreur à la mise à jour de l'image, ${res.message}`, { type: "warning" });
												doReload();
											}
										});
									} else {
										toast("Association mise à jour", { type: "success" });
									}
								} else if (res.status === 409) {
									toast("Ce nom d'association est déjà utilisé", { type: "warning" });
								} else {
									toast(`Erreur: ${res.message}`, { type: "error" });
								}
							});
						}}
					>
						Sauvegarder
					</Button>
				</form>
			</Card>
			<AssociationData association={association.data}/>
			<Report association={association.data ?? dummyAssociation}/>
			<div/>
			{ user?.scope === EUserScope.Root &&
			<Card className={"border-red border-2 flex justify-between items-center"}>
				<p className={"text-red"}>Zone de danger</p>
				<ButtonDanger onClick={() => { setVisible(true); }}>
					Supprimer
				</ButtonDanger>
				<Modal
					visible={visible}
					width={"xl:w-2/5"}
					setVisible={setVisible}
					title={`Supprimer l'association ${association.data?.name}`}
				>
					<div className={"flex justify-around"}>
						<ButtonDanger
							onClick={() => {
								api(`/associations/${association.data?.id}`, { method: "DELETE" }).then((res) => {
									if (res.status === 200) {
										toast("Association supprimé", { type: "success" });
										navigate("/associations");
									} else {
										toast(res.message, { type: "error" });
									}
								});
							}}
						>
							Oui, supprimer
						</ButtonDanger>
						<Button onClick={() => { setVisible(false); }}>
							Annuler
						</Button>
					</div>
				</Modal>
			</Card> }
		</div>
	);
}
