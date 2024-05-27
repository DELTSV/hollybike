import { useParams } from "react-router-dom";
import { useApi } from "../utils/useApi.ts";
import { TAssociation } from "../types/TAssociation.ts";
import { useSideBar } from "../sidebar/useSideBar.tsx";
import { useEffect } from "preact/hooks";
import { Card } from "../components/Card/Card.tsx";

export function Association() {
	const { id } = useParams();

	const association = useApi<TAssociation>(`/associations/${id}`);

	const { setAssociation } = useSideBar();

	useEffect(() => {
		if (association.data)
			setAssociation(association.data);
	}, [association, setAssociation]);
	return (
		<div className={"flex items-start gap-2"}>
			<Card>
				<p>Association : { association.data?.name }</p>
				<p>Statut : { association.data?.status }</p>
				<p>Image : { association.data?.picture }</p>
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
