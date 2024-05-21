import {
	api, useApi,
} from "../utils/useApi.ts";
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";
import { Button } from "../components/Button/Button.tsx";
import {
	useEffect, useState,
} from "preact/hooks";
import { TConf } from "../types/TConf.ts";
import { ConfDB } from "./ConfDB.tsx";
import { ConfSecurity } from "./ConfSecurity.tsx";
import { ConfSMTP } from "./ConfSMTP.tsx";
import { ConfS3 } from "./ConfS3.tsx";
import { ConfFTP } from "./ConfFTP.tsx";

export interface ConfProps {
	conf?: TConf
	setConf: (value: (prev: TConf | undefined) => TConf | undefined) => void
	baseConf?: TConf
}

export function Conf() {
	const [reload, setReload] = useState(false);
	const [conf, setConf] = useState<TConf>();
	const confAPI = useApi<TConf, never>("/conf", [reload]);

	useEffect(() => {
		setConf(confAPI.data);
	}, [setConf, confAPI]);

	return (
		<div className={"flex p-2 gap-2 flex-col items-start"}>
			<div className={"flex gap-2"}>
				<ConfDB conf={conf} setConf={setConf} baseConf={confAPI.data}/>
				<ConfSecurity conf={conf} setConf={setConf} baseConf={confAPI.data}/>
				<ConfSMTP conf={conf} setConf={setConf} baseConf={confAPI.data}/>
			</div>
			<div className={"flex gap-2"}>
				<ConfS3 conf={conf} setConf={setConf} baseConf={confAPI.data}/>
				<ConfFTP conf={conf} setConf={setConf} baseConf={confAPI.data}/>
				<Card>
					<h1 className={"text-xl pb-4"}>Local</h1>
					<div className={"grid grid-cols-2 gap-2 items-center"}>
						<p>Chemin local:</p><Input onInput={() => {}} value={conf?.storage?.localPath ?? ""}/>
					</div>
				</Card>
			</div>
			<Button
				onClick={() => {
					api<TConf, TConf>(
						"/conf",
						{
							method: "PUT",
							body: conf,
						},
					).then(() => {
						setReload(prev => !prev);
						// api("/restart", { method: "DELETE" });
					});
				}}
			>
				Sauvegarder
			</Button>
		</div>
	);
}
