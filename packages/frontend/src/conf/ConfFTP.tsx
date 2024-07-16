/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { ConfProps } from "./Conf.tsx";
import {
	DeleteOutlined, Visibility, VisibilityOff,
} from "@material-ui/icons";
import { useState } from "preact/hooks";
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";

export function ConfFTP(props: ConfProps) {
	const {
		conf, setConf,
	} = props;

	const [visiblePassword, setVisiblePassword] = useState(false);

	return (
		<Card>
			<div className={"flex justify-between"}>
				<h1 className={"text-xl pb-4"}>FTP</h1>
				<DeleteOutlined
					className={"cursor-pointer"}
					onClick={() => setConf(prev => ({
						...prev,
						storage: {
							...prev?.storage,
							ftpServer: undefined,
							ftpDirectory: undefined,
							ftpUsername: undefined,
							ftpPassword: undefined,
						},
					}))}
				/>
			</div>
			<div className={"grid grid-cols-2 gap-2 items-center"}>
				<p>URL:</p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								ftpServer: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.ftpServer ?? ""}
				/>
				<p>Chemin distant:</p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								ftpDirectory: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.ftpDirectory ?? ""}
				/>
				<p>Utilisateur:</p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								ftpUsername: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.ftpUsername ?? ""}
				/>
				<p>Mot de passe:</p><Input
					type={visiblePassword ? "text" : "password"}
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								ftpPassword: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.ftpPassword ?? ""}
					onFocusIn={(e) => {
						if (e.currentTarget.value === "******") {
							setConf(prev => (
								{
									...prev,
									db: {
										...prev?.db,
										password: "",
									},
								}
							));
						}
					}}
					onFocusOut={(e) => {
						if (e.currentTarget.value === "" && props.baseConf?.db?.password === "******") {
							setConf(prev => (
								{
									...prev,
									db: {
										...prev?.db,
										password: "******",
									},
								}
							));
						}
					}}
					rightIcon={visiblePassword ?
						<VisibilityOff className={"cursor-pointer"} onClick={() => setVisiblePassword(false)}/> :
						<Visibility className={"cursor-pointer"} onClick={() => setVisiblePassword(true)}/>}
				/>
			</div>
		</Card>
	);
}
