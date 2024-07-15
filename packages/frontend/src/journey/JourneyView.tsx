import Map, {
	Layer, LineLayer, LngLatBoundsLike, MapGeoJSONFeature, MapRef, Source,
} from "react-map-gl";
import { useApi } from "../utils/useApi.ts";
import {
	useNavigate, useParams,
} from "react-router-dom";

import { TJourney } from "../types/TJourney.ts";
import {
	useCallback,
	useEffect, useState,
} from "preact/hooks";
import { useRef } from "react";
import { ArrowBack } from "@material-ui/icons";

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

export function JourneyView() {
	const { id } = useParams();
	const journey = useApi<TJourney>(`/journeys/${id}`);
	const [data, setData] = useState<MapGeoJSONFeature>();
	const navigate = useNavigate();

	useEffect(() => {
		if (journey.data && journey.data.file) {
			fetch(journey.data.file).then( async (res) => {
				const data: MapGeoJSONFeature = await res.json();
				if (data.bbox?.length === 6) {
					data.bbox = [
						data.bbox[0],
						data.bbox[1],
						data.bbox[3],
						data.bbox[4],
					];
				}
				setData(data);
			});
		}
	}, [journey, setData]);

	const mapRef = useRef<MapRef>(null);

	useEffect(() => {
		if (data && data.bbox && mapRef.current) {
			mapRef.current.fitBounds(data.bbox as LngLatBoundsLike, { padding: 40 });
		}
	}, [data, mapRef]);

	const [viewState, setViewState] = useState({
		longitude: 1.2084545,
		latitude: 44.3392763,
		zoom: 4,
	});

	const onLoad = useCallback(() => {
		if (mapRef.current !== null) {
			mapRef.current.getMap().getStyle().layers.filter(l => l.id.includes("label")).forEach((l) => {
				mapRef.current?.getMap().setLayoutProperty(l.id, "text-field", ["get", "name_fr"]);
			});
		}
	}, [mapRef, mapRef.current]);

	return (
		<div className={"grow flex flex-col gap-2 p-2 overflow-hidden h-full"}>
			<div>
				<ArrowBack className={"cursor-pointer"} onClick={() => navigate(-1)}/>
			</div>
			<div className={"grow rounded overflow-hidden flex flex-col"}>
				<Map
					{...viewState}
					style={{ flexGrow: "1" }}
					mapLib={import("mapbox-gl")}
					mapStyle={"mapbox://styles/mapbox/navigation-night-v1"}
					mapboxAccessToken={accessToken}
					onMove={evt => setViewState(evt.viewState)}
					ref={mapRef}
					onLoad={onLoad}
				>
					<Source id="tracks" type="geojson" data={data}>
						<Layer {...layerStyle}/>
					</Source>
				</Map>
			</div>
		</div>
	);
}
