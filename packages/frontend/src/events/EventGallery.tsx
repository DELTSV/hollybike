import {
	useEffect, useState,
} from "preact/hooks";
import { TEventImage } from "../types/TEventImage.ts";
import {
	api, apiRaw,
} from "../utils/useApi.ts";
import { TList } from "../types/TList.ts";
import { Card } from "../components/Card/Card.tsx";
import { FileInput } from "../components/Input/FileInput.tsx";
import { Button } from "../components/Button/Button.tsx";
import { useReload } from "../utils/useReload.ts";
import { toast } from "react-toastify";

interface EventGalleryProps {
	eventId: number
}

export function EventGallery(props: EventGalleryProps) {
	const {
		reload, doReload,
	} = useReload();
	const [images, setImages] = useState<Record<number, TEventImage>>({});
	const [page, setPage] = useState(0);
	const [file, setFile] = useState<File | null>(null);
	const [done, setDone] = useState(false);
	useEffect(() => {
		api<TList<TEventImage>>(
			`/events/images?per_page=20&page=${page}&sort=upload_date_time.desc&id_event=eq:${props.eventId}`,
			{ if: props.eventId !== -1 && !done },
		).then((res) => {
			if (res.status === 200 && res.data) {
				const tmp = { ...images };
				res.data.data.forEach((i) => {
					tmp[i.id] = i;
				});
				if (res.data.data.length === 0) {
					setDone(true);
				}
				setImages(tmp);
			}
		});
	}, [
		props.eventId,
		setImages,
		page,
		reload,
	]);
	return (
		<Card className={"overflow-hidden flex flex-col min-h-96 grid-flow-row grow"}>
			<div className={"flex justify-between gap-2 items-center"}>
				<h2 className={"text-2xl"}>Galerie</h2>
				<div className={"flex items-center gap-2"}>
					<p>Ajouter une image</p>
					<FileInput value={file} placeholder={"Image"} setValue={setFile}/>
					<Button
						disabled={file === null} onClick={() => {
							if (file !== null) {
								const fd = new FormData();
								fd.append("file", file);
								apiRaw(`/events/${props.eventId}/images`, undefined, {
									body: fd,
									method: "POST",
									if: props.eventId !== -1,
								}).then((res) => {
									if (res.status === 201) {
										toast("Image ajoutée", { type: "success" });
										setPage(0);
										setDone(false);
										doReload();
									}
								});
							}
						}}
					>Valider
					</Button>
				</div>
			</div>
			<div
				className={"overflow-y-auto grow grid grid-cols-2"} onScroll={(e) => {
					const bottom = e.currentTarget.scrollHeight - e.currentTarget.scrollTop === e.currentTarget.clientHeight;
					if (bottom && ! done) {
						setPage(prev => prev + 1);
					}
				}}
			>
				<div>
					{ Object.values(images).filter((_image, i) => i % 2 === 0).map(i =>
						<img src={i.url}/>) }
				</div>
				<div>
					{ Object.values(images).filter((_image, i) => i % 2 === 1).map(i =>
						<img src={i.url}/>) }
				</div>

			</div>
		</Card>
	);
}
