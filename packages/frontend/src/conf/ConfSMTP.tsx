import { ConfProps } from "./Conf.tsx";
import {
	DeleteOutlined, Visibility, VisibilityOff,
} from "@material-ui/icons";
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";
import { useState } from "preact/hooks";

export function ConfSMTP(props: ConfProps) {
	const {
		conf, setConf,
	} = props;

	const [visiblePassword, setVisiblePassword] = useState(false);

	return (
		<Card>
			<div className={"flex justify-between"}>
				<h1 className={"text-xl pb-4"}>SMTP</h1>
				<DeleteOutlined
					className={"cursor-pointer"}
					onClick={() => setConf(prev => ({
						...prev,
						smtp: {},
					}))}
				/>
			</div>
			<div className={"grid grid-cols-2 gap-2 items-center"}>
				<p>URL:</p><Input
					onInput={e => setConf(prev => ({
						...prev,
						smtp: {
							...prev?.smtp,
							url: e.currentTarget.value,
						},
					}))} value={conf?.smtp?.url ?? ""}
				/>
				<p>Port:</p><Input
					type={"number"}
					onInput={e => setConf(prev => ({
						...prev,
						smtp: {
							...prev?.smtp,
							port: e.currentTarget.value.length > 0 ? parseInt(e.currentTarget.value) : undefined,
						},
					}))} value={conf?.smtp?.port?.toString() ?? ""}
				/>
				<p>Envoyeur:</p><Input
					onInput={e => setConf(prev => ({
						...prev,
						smtp: {
							...prev?.smtp,
							sender: e.currentTarget.value,
						},
					}))} value={conf?.smtp?.sender ?? ""}
				/>
				<p>Utilisateur:</p><Input
					onInput={e => setConf(prev => ({
						...prev,
						smtp: {
							...prev?.smtp,
							username: e.currentTarget.value,
						},
					}))} value={conf?.smtp?.username ?? ""}
				/>
				<p>Mot de passe:</p><Input
					type={visiblePassword ? "text" : "password"}
					onInput={e => setConf(prev => ({
						...prev,
						smtp: {
							...prev?.smtp,
							password: e.currentTarget.value,
						},
					}))} value={conf?.smtp?.password ?? ""}
					onFocusIn={(e) => {
						if (e.currentTarget.value === "******")
							setConf(prev => (
								{
									...prev,
									security: {
										...prev?.security,
										secret: "",
									},
								}
							));
					}}
					onFocusOut={(e) => {
						if (e.currentTarget.value === "" && props.baseConf?.db?.password === "******")
							setConf(prev => (
								{
									...prev,
									security: {
										...prev?.security,
										secret: "******",
									},
								}
							));
					}}
					rightIcon={visiblePassword ?
						<VisibilityOff className={"cursor-pointer"} onClick={() => setVisiblePassword(false)}/> :
						<Visibility className={"cursor-pointer"} onClick={() => setVisiblePassword(true)}/>}
				/>
			</div>
		</Card>
	);
}
