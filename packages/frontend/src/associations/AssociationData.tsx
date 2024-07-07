import { Card } from "../components/Card/Card.tsx";
import { useApi } from "../utils/useApi.ts";
import { TAssociation } from "../types/TAssociation.ts";
import { TAssociationData } from "../types/TAssociationData.ts";

interface AssociationDataProps {
	association?: TAssociation
}

export function AssociationData(props: AssociationDataProps) {
	const data = useApi<TAssociationData>(
		`/associations/${props.association?.id}/data`,
		[props.association?.id],
		{ if: props.association !== undefined },
	);
	return (
		<Card>
			<p>Nombre d'utilisateurs : { data.data?.total_user }</p>
			<p>Nombre d'évènements : { data.data?.total_event }</p>
			<p>Nombre de balades : { data.data?.total_event_with_journey }</p>
			<p>Nombre de trajets : { data.data?.total_journey }</p>
		</Card>
	);
}
