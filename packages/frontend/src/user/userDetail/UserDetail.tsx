import { useParams } from "react-router-dom";
import {
	api, useApi,
} from "../../utils/useApi.ts";
import { TUser } from "../../types/TUser.ts";
import { Card } from "../../components/Card/Card.tsx";
import { useReload } from "../../utils/useReload.ts";
import { Input } from "../../components/Input/Input.tsx";
import {
	useEffect, useState,
} from "preact/hooks";
import { dummyAssociation } from "../../types/TAssociation.ts";
import { Button } from "../../components/Button/Button.tsx";
import {
	Visibility, VisibilityOff,
} from "@material-ui/icons";
import { TUserUpdate } from "../../types/TUserUpdate.ts";
import { Select } from "../../components/Select/Select.tsx";

const emptyUser: TUser = {
	id: -1,
	username: "",
	email: "",
	status: "Enabled",
	scope: "User",
	last_login: "",
	association: dummyAssociation,
};

export function UserDetail() {
	const { id } = useParams();

	const {
		reload, doReload,
	} = useReload();

	const user = useApi<TUser>(`/users/${ id}`, [reload]);

	const [userData, setUserData] = useState<TUser>(emptyUser);

	const [password, setPassword] = useState("");
	const [passwordVisible, setPasswordVisible] = useState(false);

	useEffect(() => {
		if (user.data !== undefined)
			setUserData(user.data);
	}, [user]);

	return (
		<Card>
			<div className={"grid gap-2 grid-cols-2"}>
				<p>Nom de l'utilisateur</p>
				<Input
					value={userData.username} onInput={e => setUserData(prev => ({
						...prev!,
						username: e.currentTarget.value,
					}))}
				/>
				<p>Email</p>
				<Input
					value={userData.email} onInput={e => setUserData(prev => ({
						...prev!,
						email: e.currentTarget.value,
					}))}
				/>
				<p>Mot de passe</p>
				<Input
					placeholder={"·······"}
					type={passwordVisible ? "text" : "password"}
					value={password} onInput={e => setPassword(e.currentTarget.value) }
					rightIcon={passwordVisible ?
						<VisibilityOff className={"cursor-pointer"} onClick={() => setPasswordVisible(false)}/> :
						<Visibility className={"cursor-pointer"} onClick={() => setPasswordVisible(true)}/>}
				/>
				<p>Rôle</p>
				<Select
					value={userData.scope}
					onChange={v => setUserData(prev => ({
						...prev,
						scope: v!.toString(),
					}))}
					options={[
						{
							name: "Utilisateur",
							value: "User",
						},
						{
							name: "Administrateur",
							value: "Admin",
						},
						{
							name: "Root",
							value: "Root",
						},
					]}
					default={userData.scope}
				/>
				<p>Statut</p>
				<Select
					value={userData.status}
					onChange={v => setUserData(prev => ({
						...prev,
						status: v!.toString(),
					}))}
					options={[
						{
							name: "Activé",
							value: "Enabled",
						},
						{
							name: "Désactivé",
							value: "Disabled",
						},
					]}
					default={userData.status}
				/>
			</div>
			<Button
				onClick={() => {
					const data: TUserUpdate = {
						username: userData.username,
						email: userData.email,
						password: password.length !== 0 ? password : undefined,
						status: userData.status,
						scope: userData.scope,
						association: userData.association.id,
					};
					api(`/users/${ userData.id}`, {
						method: "PATCH",
						body: data,
					}).then((res) => {
						if (res.status === 200)
							doReload();
						else
							console.log(res.message);
					});
				}}
			>
				Sauvegarder
			</Button>
		</Card>
	);
}
