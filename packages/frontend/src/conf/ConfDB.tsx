import { Input } from "../components/Input/Input.tsx";
import { Card } from "../components/Card/Card.tsx";
import { ConfProps } from "./Conf.tsx";
import { useState } from "preact/hooks";
import {
	DeleteOutlined,
	Visibility, VisibilityOff,
} from "@material-ui/icons";
import { RedStar } from "../components/RedStar/RedStar.tsx";

export function ConfDB(props: ConfProps) {
	const {
		conf, setConf,
	} = props;

	const [visiblePassword, setVisiblePassword] = useState(false);

	return (
		<Card>
			<div className={"flex justify-between"}>
				<h1 className={"text-xl pb-4"}>Base de données (obligatoire)</h1>
				<DeleteOutlined
					className={"cursor-pointer"}
					onClick={() => setConf(prev => ({
						...prev,
						db: {},
					}))}
				/>
			</div>
			<div className={"grid grid-cols-2 gap-2 items-center"}>
				<p>URL: <RedStar/></p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							db: {
								...prev?.db,
								url: e.currentTarget.value,
							},
						}
					))}
					value={conf?.db?.url ?? ""}
				/>
				<p>Nom d'utilisateur: <RedStar/></p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							db: {
								...prev?.db,
								username: e.currentTarget.value,
							},
						}
					))}
					value={conf?.db?.username ?? ""}
				/>
				<p>Mot de passe: <RedStar/></p><Input
					type={visiblePassword ? "text" : "password"}
					onInput={e => setConf(prev => (
						{
							...prev,
							db: {
								...prev?.db,
								password: e.currentTarget.value,
							},
						}
					))}
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
					value={conf?.db?.password ?? ""}
					rightIcon={visiblePassword ?
						<VisibilityOff className={"cursor-pointer"} onClick={() => setVisiblePassword(false)}/> :
						<Visibility className={"cursor-pointer"} onClick={() => setVisiblePassword(true)}/>}
				/>
			</div>
		</Card>
	);
}
