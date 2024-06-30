import { useParams } from "react-router-dom";
import { useApi } from "../utils/useApi.ts";
import { TUser } from "../types/TUser.ts";
import { TEvent } from "../types/TEvent.ts";
import { Card } from "../components/Card/Card.tsx";
import { distanceToHumanReadable } from "../utils/distanceToHumanReadable.ts";
import { TUserJourney } from "../types/TUserJourney.ts";
import Map, {
	Layer, LineLayer, MapRef, Source,
} from "react-map-gl";
import {
	useCallback, useState,
} from "preact/hooks";
import { useRef } from "react";

const accessToken = import.meta.env.VITE_MAPBOX_KEY;

const layerStyle: LineLayer = {
	id: "point",
	type: "line",
	layout: {
		"line-join": "round",
		"line-cap": "round",
	},
	paint: {
		"line-color": "#3457D5",
		"line-width": 5,
		"line-opacity": 1,
	},
};

export function EventParticipantJourney() {
	const {
		id, idparticipant,
	} = useParams();
	const user = useApi<TUser>(`/users/${idparticipant}`);
	const event = useApi<TEvent>(`/events/${id}`);
	const journey = useApi<TUserJourney>(`/events/${id}/participations/${idparticipant}/journey`);
	const mapRef = useRef<MapRef>(null);
	const [viewState, setViewState] = useState({
		longitude: 1.2084545,
		latitude: 44.3392763,
		zoom: 4,
	});

	const onLoad = useCallback(() => {
		if (mapRef.current !== null) {
			mapRef.current.resize();
			mapRef.current.getMap().getStyle().layers.filter(l => l.id.includes("label")).forEach((l) => {
				mapRef.current?.getMap().setLayoutProperty(l.id, "text-field", ["get", "name_fr"]);
			});
		}
	}, [mapRef]);

	return (
		<div className={"mx-2 flex flex-col gap-2"}>
			<h1>Trajet de { user.data?.username } lors de l'évènement { event.data?.name }</h1>
			<Card className={"grid grid-cols-2"}>
				<p>Distance totale</p>
				<p>{ distanceToHumanReadable(journey.data?.total_distance) }</p>
				<div className={"flex gap-4 col-span-2"}>
					<p>Altitude max: { distanceToHumanReadable(journey.data?.max_elevation) }</p>
					<p>Altitude min: { distanceToHumanReadable(journey.data?.min_elevation) }</p>
					<p>Dénivelé positif: { distanceToHumanReadable(journey.data?.total_elevation_gain) }</p>
					<p>Dénivelé négatif: { distanceToHumanReadable(journey.data?.total_elevation_loss) }</p>
				</div>
				<div className={"flex gap-4 col-span-2"}>
					<p>Temps total: { journey.data?.total_time }</p>
					<p>Vitesse moyenne: { journey.data?.avg_speed }</p>
					<p>Vitesse de pointe: { journey.data?.max_speed }</p>
				</div>
			</Card>
			<Card className={"grow mb-2"}>
				<Map
					ref={mapRef}
					{...viewState}
					onMove={evt => setViewState(evt.viewState)}
					style={{
						height: "calc(100% - 48px)",
						width: "100%",
					}}

					mapLib={import("mapbox-gl")}
					mapStyle={"mapbox://styles/mapbox/navigation-night-v1"}
					mapboxAccessToken={accessToken}
					onLoad={onLoad}
				>
					<Source id="tracks" type="geojson" data={journey.data?.file}>
						<Layer {...layerStyle}/>
					</Source>
				</Map>
			</Card>
		</div>
	);
}
