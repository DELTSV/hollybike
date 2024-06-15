import Map, {
	Layer, LineLayer, MapGeoJSONFeature, MapRef, Source,
} from "react-map-gl";
import { useApi } from "../utils/useApi.ts";
import { useParams } from "react-router-dom";

import { TJourney } from "../types/TJourney.ts";
import {
	useCallback,
	useEffect, useState,
} from "preact/hooks";
import { useRef } from "react";

const accessToken = import.meta.env.VITE_MAPBOX_KEY;

const layerStyle: LineLayer = {
	id: "point",
	type: "line",
	paint: {
		"line-color": "#FF0000",
		"line-width": 8,
	},
};
export function JourneyView() {
	const { id } = useParams();
	const journey = useApi<TJourney>(`/journeys/${id}`);
	const [data, setData] = useState<MapGeoJSONFeature>();

	useEffect(() => {
		if (journey.data && journey.data.file) {
			fetch(journey.data.file).then( async (res) => {
				const data = await res.json();
				setData(data);
			});
		}
	}, [journey, setData]);

	const mapRef = useRef<MapRef>(null);

	useEffect(() => {
		if (data && data.bbox && mapRef.current) {
			console.log(data.bbox);
			if (data.bbox.length == 4) {
				mapRef.current.fitBounds(data.bbox);
			} else if (data.bbox.length === 6) {
				const bounds: [number, number, number, number] = [
					data.bbox[0],
					data.bbox[1],
					data.bbox[3],
					data.bbox[4],
				];
				mapRef.current.fitBounds(bounds, {
					padding: {
						top: 10,
						bottom: 10,
						left: 10,
						right: 10,
					},
				});
			}
		}
	}, [data, mapRef]);

	const [viewState, setViewState] = useState({
		longitude: -100,
		latitude: 40,
		zoom: 0,
	});

	const onLoad = useCallback(() => {
		if (mapRef.current !== null) {
			mapRef.current.getMap().getStyle().layers.filter(l => l.id.includes("label")).forEach((l) => {
				mapRef.current?.getMap().setLayoutProperty(l.id, "text-field", ["get", "name_fr"]);
			});
		}
	}, [mapRef, mapRef.current]);

	return (
		<div className={"w-full h-full"}>
			<Map
				{...viewState}
				style={{ height: "100%" }}
				mapLib={import("mapbox-gl")}
				mapStyle={"mapbox://styles/mapbox/navigation-night-v1"}
				mapboxAccessToken={accessToken}
				onMove={evt => setViewState(evt.viewState)}
				ref={mapRef}
				onLoad={onLoad}
			>
				<Source id="my-data" type="geojson" data={journey.data?.file}>
					<Layer {...layerStyle}/>
				</Source>
			</Map>
		</div>
	);
}
