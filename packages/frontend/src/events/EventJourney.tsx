import { Card } from "../components/Card/Card.tsx";
import { FileInput } from "../components/Input/FileInput.tsx";
import {
	useCallback,
	useEffect, useState,
} from "preact/hooks";
import { Button } from "../components/Button/Button.tsx";
import {
	api, apiRaw,
} from "../utils/useApi.ts";
import { DoReload } from "../utils/useReload.ts";
import { TEventDetail } from "../types/TEventDetail.ts";
import { Input } from "../components/Input/Input.tsx";
import { TJourney } from "../types/TJourney.ts";
import { toast } from "react-toastify";
import { positionToString } from "../utils/positionToString.ts";
import { distanceToHumanReadable } from "../utils/distanceToHumanReadable.ts";

interface EventJourneyProps {
	eventDetail?: TEventDetail,
	doReload: DoReload
}

export function EventJourney(props: EventJourneyProps) {
	const [file, setFile] = useState<File | null>(null);
	const [name, setName] = useState("");
	useEffect(() => {
		setName(props.eventDetail?.journey?.name ?? "");
	}, [props.eventDetail?.journey?.name]);

	const createJourney = useCallback(async () => {
		if (name !== "" && file) {
			const res = await api<TJourney>("/journeys", {
				method: "POST",
				body: {
					name: name,
					association: props.eventDetail?.event?.id ?? -1,
				},
			});
			if (res.status === 201 && res.data) {
				const fd = new FormData();
				fd.append("file", file);
				const fileRes = await apiRaw<TJourney>(`/journeys/${res.data.id}/file`, undefined, {
					method: "POST",
					body: fd,
				});
				if (fileRes.status === 200) {
					const joinRes = await api(`/events/${props.eventDetail?.event.id}/journey`, {
						method: "POST",
						body: { journey_id: fileRes.data?.id },
					});
					if (joinRes.status === 200) {
						props.doReload();
						toast("Trajet créer", { type: "success" });
					}
				} else {
					toast(fileRes.message, { type: "error" });
				}
			} else {
				toast(res.message, { type: "error" });
			}
		}
	}, [
		props.eventDetail?.event?.id,
		props.doReload,
		toast,
		file,
	]);

	const updateJourney = useCallback(async () => {
		if (name !== "" && file && props.eventDetail?.journey) {
			const fd = new FormData();
			fd.append("file", file);
			const fileRes = await apiRaw<TJourney>(`/journeys/${props.eventDetail.journey.id}/file`, undefined, {
				method: "POST",
				body: fd,
			});
			if (fileRes.status === 200) {
				props.doReload();
				toast("Trajet mis à jour", { type: "success" });
			} else {
				toast(fileRes.message, { type: "error" });
			}
		}
	}, [
		props.eventDetail?.journey,
		props.doReload,
		toast,
		file,
	]);

	return (
		<Card className={"grid grid-cols-[1fr_3fr] gap-4 items-center"}>
			<p className={"col-span-2 text-center"}>Trajet: { props.eventDetail?.journey?.name ?? "Aucun trajet" }</p>
			<p>Nom</p>
			<Input placeholder={"Nom"} value={name} onInput={e => setName(e.currentTarget.value)}/>
			<p>Fichier</p>
			<FileInput value={file} setValue={setFile} placeholder={"Fichier"} accept={".geojson,.gpx"}/>
			{ props.eventDetail?.journey &&
				<>
					<p>Départ</p>
					<p>{ positionToString(props.eventDetail.journey.start) }</p>
					<p>Arrivée</p>
					<p>{ positionToString(props.eventDetail.journey.end) }</p>
					<p>Destination</p>
					<p>{ positionToString(props.eventDetail.journey.destination) }</p>
					<p>Distance totale</p>
					<p>{ distanceToHumanReadable(props.eventDetail.journey.totalDistance) }</p>
					<div className={"flex gap-4 col-span-2"}>
						<p>Altitude max: { distanceToHumanReadable(props.eventDetail.journey.maxElevation) }</p>
						<p>Altitude min: { distanceToHumanReadable(props.eventDetail.journey.minElevation) }</p>
						<p>Dénivelé positif: { distanceToHumanReadable(props.eventDetail.journey.totalElevationGain) }</p>
						<p>Dénivelé négatif: { distanceToHumanReadable(props.eventDetail.journey.totalElevationLoss) }</p>
					</div>
				</> }
			<Button
				disabled={name === "" || file === null}
				className={"col-span-2 justify-self-center"}
				onClick={async () => {
					if (!props.eventDetail?.journey) {
						await createJourney();
					} else {
						await updateJourney();
					}
				}}
			>
				Envoyer
			</Button>
		</Card>
	);
}
