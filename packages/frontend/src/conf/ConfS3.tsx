import { ConfProps } from "./Conf.tsx";
import {
	DeleteOutlined, Visibility, VisibilityOff,
} from "@material-ui/icons";
import { useState } from "preact/hooks";
import { Card } from "../components/Card/Card.tsx";
import { Input } from "../components/Input/Input.tsx";

export function ConfS3(props: ConfProps) {
	const {
		conf, setConf,
	} = props;

	const [visiblePassword, setVisiblePassword] = useState(false);

	return (
		<Card>
			<div className={"flex justify-between"}>
				<h1 className={"text-xl pb-4"}>S3</h1>
				<DeleteOutlined
					className={"cursor-pointer"}
					onClick={() => setConf(prev => ({
						...prev,
						storage: {
							...prev?.storage,
							s3Url: undefined,
							s3Bucket: undefined,
							s3Region: undefined,
							s3Username: undefined,
							s3Password: undefined,
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
								s3Url: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.s3Url ?? ""}
				/>
				<p>Bucket:</p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								s3Bucket: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.s3Bucket ?? ""}
				/>
				<p>Region:</p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								s3Region: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.s3Region ?? ""}
				/>
				<p>Utilisateur:</p><Input
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								s3Username: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.s3Username ?? ""}
				/>
				<p>Mot de passe:</p><Input
					type={visiblePassword ? "text" : "password"}
					onInput={e => setConf(prev => (
						{
							...prev,
							storage: {
								...prev?.storage,
								s3Password: e.currentTarget.value,
							},
						}
					))} value={conf?.storage?.s3Password ?? ""}
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
