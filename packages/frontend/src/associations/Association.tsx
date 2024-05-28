import { useParams } from "react-router-dom";
import {
	api, useApi,
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

export function Association() {
	const { user } = useUser();

	const { id } = useParams();

	const association = useApi<TAssociation>(`/associations/${id}`);

	const [associationData, setAssociationData] = useState(dummyAssociation);

	const { setAssociation } = useSideBar();

	useEffect(() => {
		if (association.data) {
			setAssociation(association.data);
			setAssociationData(association.data);
		}
	}, [association, setAssociation]);
	return (
		<div className={"flex items-start gap-2"}>
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
				<p>Image :</p>
				<img alt={"Logo de l'association"} src={""}/>
				<Button
					className={"justify-self-center col-span-2"}
					onClick={() => {
						const url = user?.scope === "Admin" ? "/associations/me" : `/associations/${associationData.id}`;
						api<TAssociation>(url, {
							method: "PATCH",
							body: associationData,
						}).then((res) => {
							if (res.status === 200 && res.data)
								setAssociationData(res.data);
							else
								console.log(res.message);
						});
					}}
				>
					Sauvegarder
				</Button>
			</Card>
			<Card>
				<p>Nombre d'utilisateur : TODO</p>
				<p>Nombre d'évènements : TODO</p>
				<p>Nombre de balade : TODO</p>
				…
			</Card>
		</div>
	);
}
