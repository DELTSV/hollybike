import { Card } from "../components/Card/Card.tsx";
import { InputCalendar } from "../components/Calendar/InputCalendar.tsx";
import { Button } from "../components/Button/Button.tsx";
import {
	useEffect, useMemo, useState,
} from "preact/hooks";
import { apiResponseRaw } from "../utils/useApi.ts";
import { TAssociation } from "../types/TAssociation.ts";
import { useRef } from "react";
import { Input } from "../components/Input/Input.tsx";

interface ReportProps {
	association: TAssociation
}

export function Report(props: ReportProps) {
	const [start, setStart] = useState<Date | undefined>(new Date());
	const [end, setEnd] = useState<Date | undefined>(new Date());
	useEffect(() => {
		setStart((prev) => {
			if (prev) {
				const tmp = new Date();
				tmp.setFullYear(prev?.getFullYear() - 1);
				return tmp;
			} else {
				return prev;
			}
		});
	}, [setStart]);
	const [year, setYear] = useState<number>(new Date().getFullYear());
	const titleYear = useMemo(() => `Rapport_de_dépense_de_l'année_${year}`, [year]);
	const titlePeriod = useMemo(() => `Rapport_de_dépense_de_${start}_à_${end}`, [year]);
	const downloadLinkYear = useRef<HTMLAnchorElement>(null);
	const downloadLinkPeriod = useRef<HTMLAnchorElement>(null);
	return (
		<>
			<a className={"hidden"} ref={downloadLinkYear} title={titleYear}/>
			<a className={"hidden"} ref={downloadLinkPeriod} title={titlePeriod}/>
			<Card className={"grid grid-cols-2 gap-4"}>
				<p className={"col-span-2 text-xl"}>Rapport sur la période</p>
				<p>Début</p>
				<InputCalendar value={start} setValue={setStart}/>
				<p>Fin</p>
				<InputCalendar value={end} setValue={setEnd}/>
				<Button
					className={"col-span-2 justify-self-center"}
					onClick={async () => {
						const resp = await apiResponseRaw(
							`/associations/${props.association.id}/expenses?start=${start?.toISOString()}&end=${end?.toISOString()}`,
							"text/csv",
							{ if: start !== undefined && end !== undefined && props.association.id !== -1 },
						);
						const data = await resp.blob();
						const url = URL.createObjectURL(data);
						if (downloadLinkYear.current) {
							downloadLinkYear.current.href = url;
							downloadLinkYear.current.click();
						}
					}}
				>Télécharger
				</Button>
			</Card>
			<div/>
			<Card className={"grid grid-cols-2 gap-4 items-center"}>
				<h1 className={"text-xl col-span-2"}>Rapport CSV de l'année</h1>
				<p>Année</p>
				<Input
					value={year.toString()} onInput={(e) => {
						const y = parseInt(e.currentTarget.value);
						if (!isNaN(y)) {
							setYear(y);
						}
					}}
				/>
				<Button
					className={"col-span-2 justify-self-center"}
					onClick={async () => {
						const resp = await apiResponseRaw(
							`/associations/${props.association.id}/expenses/year/${year}`,
							"text/csv",
							{ if: start !== undefined && end !== undefined && props.association.id !== -1 },
						);
						const data = await resp.blob();
						const url = URL.createObjectURL(data);
						if (downloadLinkYear.current) {
							downloadLinkYear.current.href = url;
							downloadLinkYear.current.click();
						}
					}}
				>Télécharger
				</Button>
			</Card>
		</>
	);
}
