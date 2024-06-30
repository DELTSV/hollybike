import { useParams } from "react-router-dom";
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

	useEffect(() => {
		if (association.data) {
			setAssociation(association.data);
			setAssociationData(association.data);
		}
	}, [association, setAssociation]);
	return (
		<form className={"flex items-start gap-2"} onSubmit={e => e.preventDefault()}>
			<Card className={"grid grid-cols-2 gap-2 items-center"}>
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
					disabled={user?.scope === "Admin"}
					value={associationData?.status}
					options={[
						{
							name: "Active",
							value: "Enabled",
						},
						{
							name: "Inactive",
							value: "Disabled",
						},
					]}
					default={associationData?.status}
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
						const url = user?.scope === "Admin" ? "/associations/me" : `/associations/${associationData.id}`;
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
			</Card>
			<AssociationData association={association.data}/>
		</form>
	);
}
