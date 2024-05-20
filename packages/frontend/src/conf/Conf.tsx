import {
api, useApi,
} from "../utils/useApi.ts";
import { TConf } from "../types/TConf.ts";
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";
import { Button } from "../components/Button/Button.tsx";

export function Conf() {
	const conf = useApi<TConf, never>("/conf");

	return (
		<div className={"flex p-2 gap-2 flex-col items-start"}>
			<div className={"flex gap-2"}>
				<Card>
					<h1 className={"text-xl pb-4"}>Base de données (obligatoire)</h1>
					<div className={"grid grid-cols-2 gap-2 items-center"}>
						<p>URL:</p><Input onInput={() => {}} value={conf.data?.db?.url ?? ""}/>
						<p>Nom d'utilisateur:</p><Input onInput={() => {}} value={conf.data?.db?.username ?? ""}/>
						<p>Mot de passe:</p><Input onInput={() => {}} value={conf.data?.db?.password ?? ""}/>
					</div>
				</Card>
				<Card>
					<h1 className={"text-xl pb-4"}>Sécurité (obligatoire)</h1>
					<div className={"grid grid-cols-2 gap-2 items-center"}>
						<p>Audience:</p><Input onInput={() => {}} value={conf.data?.security?.audience ?? ""}/>
						<p>Domaine:</p><Input onInput={() => {}} value={conf.data?.security?.domain ?? ""}/>
						<p>Realm:</p><Input onInput={() => {}} value={conf.data?.security?.realm ?? ""}/>
						<p>Secret:</p><Input onInput={() => {}} value={conf.data?.security?.secret ?? ""}/>
					</div>
				</Card>
				<Card>
					<h1 className={"text-xl pb-4"}>SMTP</h1>
					<div className={"grid grid-cols-2 gap-2 items-center"}>
						<p>URL:</p><Input onInput={() => {}} value={conf.data?.smtp?.url ?? ""}/>
						<p>Port:</p><Input onInput={() => {}} value={conf.data?.smtp?.url ?? ""}/>
						<p>Envoyeur:</p><Input onInput={() => {}} value={conf.data?.smtp?.url ?? ""}/>
						<p>Utilisateur:</p><Input onInput={() => {}} value={conf.data?.smtp?.url ?? ""}/>
						<p>Mot de passe:</p><Input onInput={() => {}} value={conf.data?.smtp?.url ?? ""}/>
					</div>
				</Card>
			</div>
			<div className={"flex gap-2"}>
				<Card>
					<h1 className={"text-xl pb-4"}>S3</h1>
					<div className={"grid grid-cols-2 gap-2 items-center"}>
						<p>URL:</p><Input onInput={() => {}} value={conf.data?.storage.s3Url ?? ""}/>
						<p>Bucket:</p><Input onInput={() => {}} value={conf.data?.storage?.s3Bucket ?? ""}/>
						<p>Region:</p><Input onInput={() => {}} value={conf.data?.storage?.s3Region ?? ""}/>
						<p>Utilisateur:</p><Input onInput={() => {}} value={conf.data?.storage?.s3Username ?? ""}/>
						<p>Mot de passe:</p><Input onInput={() => {}} value={conf.data?.storage?.s3Password ?? ""}/>
					</div>
				</Card>
				<Card>
					<h1 className={"text-xl pb-4"}>FTP</h1>
					<div className={"grid grid-cols-2 gap-2 items-center"}>
						<p>URL:</p><Input onInput={() => {}} value={conf.data?.storage.ftpServer ?? ""}/>
						<p>Chemin distant:</p><Input onInput={() => {}} value={conf.data?.storage.ftpDirectory ?? ""}/>
						<p>Utilisateur:</p><Input onInput={() => {}} value={conf.data?.storage.ftpUsername ?? ""}/>
						<p>Mot de passe:</p><Input onInput={() => {}} value={conf.data?.storage.ftpPassword ?? ""}/>
					</div>
				</Card>
				<Card>
					<h1 className={"text-xl pb-4"}>Local</h1>
					<div className={"grid grid-cols-2 gap-2 items-center"}>
						<p>Chemin local:</p><Input onInput={() => {}} value={conf.data?.storage.localPath ?? ""}/>
					</div>
				</Card>
			</div>
			<Button
				onClick={() => {
					api<TConf, TConf>(
						"/conf",
						{
							method: "PUT",
							body: conf.data,
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
