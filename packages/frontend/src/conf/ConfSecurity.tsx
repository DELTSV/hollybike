import { ConfProps } from "./Conf.tsx";
import {
	DeleteOutlined, Visibility, VisibilityOff,
} from "@material-ui/icons";
import { Card } from "../components/Card/Card.tsx";
import { useState } from "preact/hooks";
import { Input } from "../components/Input/Input.tsx";
import { RedStar } from "../components/RedStar/RedStar.tsx";

export function ConfSecurity(props: ConfProps) {
	const {
		conf, setConf,
	} = props;

	const [visiblePassword, setVisiblePassword] = useState(false);

	return (
		<Card>
			<div className={"flex justify-between"}>
				<h1 className={"text-xl pb-4"}>Sécurité (obligatoire)</h1>
				<DeleteOutlined
					className={"cursor-pointer"}
					onClick={() => setConf(prev => ({
						...prev,
						security: {},
					}))}
				/>
			</div>
			<div className={"grid grid-cols-2 gap-2 items-center"}>
				<p>Audience: <RedStar/></p><Input
					onInput={e => setConf(prev => ({
						...prev,
						security: {
							...prev?.security,
							audience: e.currentTarget.value,
						},
					}))} value={conf?.security?.audience ?? ""}
				/>
				<p>Domaine: <RedStar/></p><Input
					onInput={e => setConf(prev => ({
						...prev,
						security: {
							...prev?.security,
							domain: e.currentTarget.value,
						},
					}))} value={conf?.security?.domain ?? ""}
				/>
				<p>Realm: <RedStar/></p><Input
					onInput={e => setConf(prev => ({
						...prev,
						security: {
							...prev?.security,
							realm: e.currentTarget.value,
						},
					}))} value={conf?.security?.realm ?? ""}
				/>
				<p>Secret: <RedStar/></p><Input
					type={visiblePassword ? "text" : "password"}
					onInput={e => setConf(prev => (
						{
							...prev,
							security: {
								...prev?.security,
								secret: e.currentTarget.value,
							},
						}
					))}
					onFocusIn={(e) => {
						if (e.currentTarget.value === "******") {
							setConf(prev => (
								{
									...prev,
									security: {
										...prev?.security,
										secret: "",
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
									security: {
										...prev?.security,
										secret: "******",
									},
								}
							));
						}
					}}
					value={conf?.security?.secret ?? ""}
					rightIcon={visiblePassword ?
						<VisibilityOff className={"cursor-pointer"} onClick={() => setVisiblePassword(false)}/> :
						<Visibility className={"cursor-pointer"} onClick={() => setVisiblePassword(true)}/>}
				/>
			</div>
		</Card>
	);
}
