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

export interface ConfProps {
	conf?: TConf
	setConf: (value: (prev: TConf | undefined) => TConf | undefined) => void
	baseConf?: TConf
}

export function Conf() {
	const [conf, setConf] = useState<TConf>();
	const confAPI = useApi<TConf, never>("/conf");

	useEffect(() => {
		setConf(confAPI.data);
	}, [setConf, confAPI]);

	return (
		<div className={"flex p-2 gap-2 flex-col items-start"}>
			<div className={"flex gap-2"}>
				<ConfDB conf={conf} setConf={setConf} baseConf={confAPI.data}/>
				<Card>
					<h1 className={"text-xl pb-4"}>Sécurité (obligatoire)</h1>
					<div className={"grid grid-cols-2 gap-2 items-center"}>
						<p>Audience:</p><Input onInput={() => {}} value={conf?.security?.audience ?? ""}/>
						<p>Domaine:</p><Input onInput={() => {}} value={conf?.security?.domain ?? ""}/>
						<p>Realm:</p><Input onInput={() => {}} value={conf?.security?.realm ?? ""}/>
						<p>Secret:</p><Input onInput={() => {}} value={conf?.security?.secret ?? ""}/>
					</div>
				</Card>
				<Card>
					<h1 className={"text-xl pb-4"}>SMTP</h1>
					<div className={"grid grid-cols-2 gap-2 items-center"}>
						<p>URL:</p><Input onInput={() => {}} value={conf?.smtp?.url ?? ""}/>
						<p>Port:</p><Input onInput={() => {}} value={conf?.smtp?.url ?? ""}/>
						<p>Envoyeur:</p><Input onInput={() => {}} value={conf?.smtp?.url ?? ""}/>
						<p>Utilisateur:</p><Input onInput={() => {}} value={conf?.smtp?.url ?? ""}/>
						<p>Mot de passe:</p><Input onInput={() => {}} value={conf?.smtp?.url ?? ""}/>
					</div>
				</Card>
			</div>
			<div className={"flex gap-2"}>
				<Card>
					<h1 className={"text-xl pb-4"}>S3</h1>
					<div className={"grid grid-cols-2 gap-2 items-center"}>
						<p>URL:</p><Input onInput={() => {}} value={conf?.storage?.s3Url ?? ""}/>
						<p>Bucket:</p><Input onInput={() => {}} value={conf?.storage?.s3Bucket ?? ""}/>
						<p>Region:</p><Input onInput={() => {}} value={conf?.storage?.s3Region ?? ""}/>
						<p>Utilisateur:</p><Input onInput={() => {}} value={conf?.storage?.s3Username ?? ""}/>
						<p>Mot de passe:</p><Input onInput={() => {}} value={conf?.storage?.s3Password ?? ""}/>
					</div>
				</Card>
				<Card>
					<h1 className={"text-xl pb-4"}>FTP</h1>
					<div className={"grid grid-cols-2 gap-2 items-center"}>
						<p>URL:</p><Input onInput={() => {}} value={conf?.storage?.ftpServer ?? ""}/>
						<p>Chemin distant:</p><Input onInput={() => {}} value={conf?.storage?.ftpDirectory ?? ""}/>
						<p>Utilisateur:</p><Input onInput={() => {}} value={conf?.storage?.ftpUsername ?? ""}/>
						<p>Mot de passe:</p><Input onInput={() => {}} value={conf?.storage?.ftpPassword ?? ""}/>
					</div>
				</Card>
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
						// api("/restart", { method: "DELETE" });
					});
				}}
			>
				Sauvegarder
			</Button>
		</div>
	);
}
