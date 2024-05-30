import {
	api, useApi,
} from "../utils/useApi.ts";
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
import { ConfLocal } from "./ConfLocal.tsx";

export interface ConfProps {
	conf?: TConf
	setConf: (value: (prev: TConf | undefined) => TConf | undefined) => void
	baseConf?: TConf
}

export function Conf() {
	const [reload, setReload] = useState(false);
	const [conf, setConf] = useState<TConf>();
	const confAPI = useApi<TConf>("/conf", [reload]);

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
				<ConfLocal conf={conf} setConf={setConf} baseConf={confAPI.data}/>
			</div>
			<Button
				onClick={() => {
					api<TConf>(
						"/conf",
						{
							method: "PUT",
							body: conf,
						},
					).then(() => {
						setReload(prev => !prev);
						api("/restart", { method: "DELETE" });
					});
				}}
			>
				Sauvegarder
			</Button>
		</div>
	);
}
