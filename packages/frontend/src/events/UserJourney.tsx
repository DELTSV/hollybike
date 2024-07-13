import { useParams } from "react-router-dom";
import { useApi } from "../utils/useApi.ts";
import { Card } from "../components/Card/Card.tsx";
import { distanceToHumanReadable } from "../utils/distanceToHumanReadable.ts";
import { TUserJourney } from "../types/TUserJourney.ts";
import Map, {
	Layer, LineLayer, MapGeoJSONFeature, MapRef, Source,
} from "react-map-gl";
import {
	useCallback, useEffect, useState,
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

export function UserJourney() {
	const { id } = useParams();
	const journey = useApi<TUserJourney>(`/user-journeys/${id}`);
	const mapRef = useRef<MapRef>(null);
	const [viewState, setViewState] = useState({
		longitude: 1.2084545,
		latitude: 44.3392763,
		zoom: 4,
	});
	const [data, setData] = useState<MapGeoJSONFeature>();

	useEffect(() => {
		if (journey.data && journey.data.file) {
			fetch(journey.data.file).then( async (res) => {
				const data = await res.json();
				setData(data);
			});
		}
	}, [journey, setData]);

	const onLoad = useCallback(() => {
		if (mapRef.current !== null) {
			mapRef.current.resize();
			mapRef.current.getMap().getStyle().layers.filter(l => l.id.includes("label")).forEach((l) => {
				mapRef.current?.getMap().setLayoutProperty(l.id, "text-field", ["get", "name_fr"]);
			});
		}
	}, [mapRef]);

	useEffect(() => {
		if (data && data.bbox && mapRef.current) {
			if (data.bbox.length == 4) {
				mapRef.current.fitBounds(data.bbox, { padding: 40 });
			} else if (data.bbox.length === 6) {
				const bounds: [number, number, number, number] = [
					data.bbox[0],
					data.bbox[1],
					data.bbox[3],
					data.bbox[4],
				];
				mapRef.current.fitBounds(bounds, { padding: 40 });
			}
		}
	}, [data, mapRef]);

	return (
		<div className={"mx-2 flex flex-col gap-2 grow"}>
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
			<Card className={"grow flex flex-col"}>
				<Map
					ref={mapRef}
					{...viewState}
					onMove={evt => setViewState(evt.viewState)}
					style={{
						flexGrow: "1",
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
