import {
	useNavigate, useParams,
} from "react-router-dom";
import {
	api, useApi,
} from "../../utils/useApi.ts";
import { TUser } from "../../types/TUser.ts";
import { Card } from "../../components/Card/Card.tsx";
import { useReload } from "../../utils/useReload.ts";
import { Input } from "../../components/Input/Input.tsx";
import {
	useEffect, useMemo, useState,
} from "preact/hooks";
import { dummyAssociation } from "../../types/TAssociation.ts";
import { Button } from "../../components/Button/Button.tsx";
import {
	Visibility, VisibilityOff,
} from "@material-ui/icons";
import { TUserUpdate } from "../../types/TUserUpdate.ts";
import {
	Option, Select,
} from "../../components/Select/Select.tsx";
import { toast } from "react-toastify";
import { EUserStatus } from "../../types/EUserStatus.ts";
import {
	EUserScope, scopes, scopesName,
} from "../../types/EUserScope.ts";
import { useUser } from "../useUser.tsx";
import { ListUserJourney } from "./ListUserJourney.tsx";
import { ButtonDanger } from "../../components/Button/ButtonDanger.tsx";

const emptyUser: TUser = {
	id: -1,
	username: "",
	email: "",
	status: EUserStatus.Enabled,
	scope: EUserScope.User,
	last_login: new Date(),
	association: dummyAssociation,
};

export function UserDetail() {
	const { id } = useParams();

	const {
		reload, doReload,
	} = useReload();

	const { user: self } = useUser();

	const user = useApi<TUser>(`/users/${ id}`, [reload]);

	const [userData, setUserData] = useState<TUser>(emptyUser);

	const [password, setPassword] = useState("");
	const [passwordVisible, setPasswordVisible] = useState(false);

	const [confirm, setConfirm] = useState(false);

	useEffect(() => {
		if (user.data !== undefined) { setUserData(user.data); }
	}, [user]);

	const scopeOptions: Option[] = useMemo(() =>
		scopes.filter(s => self?.scope === EUserScope.Root || s !== "Root").map(s => ({
			name: scopesName[s],
			value: s,
		})), [self]);

	const navigate = useNavigate();

	return (
		<div className={"grid gap-2 grid-cols-2"}>
			<Card>
				<div className={"grid gap-2 grid-cols-2"}>
					<p>Nom de l'utilisateur</p>
					<Input
						value={userData.username} onInput={e => setUserData(prev => ({
							...prev!,
							username: e.currentTarget.value,
						}))}
					/>
					<p>Fonction</p>
					<Input
						placeholder={"Fonction"}
						value={userData.role ?? ""}
						onInput={e => setUserData(prev => ({
							...prev!,
							role: e.currentTarget.value,
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
							scope: (v ?? "User") as EUserScope,
						}))}
						options={scopeOptions}
						default={userData.scope}
					/>
					<p>Statut</p>
					<Select
						value={userData.status}
						onChange={v => setUserData(prev => ({
							...prev,
							status: (v ?? "Enabled") as EUserStatus,
						}))}
						options={[
							{
								name: "Activé",
								value: EUserStatus.Enabled,
							},
							{
								name: "Désactivé",
								value: EUserStatus.Disabled,
							},
						]}
						default={userData.status}
					/>
				</div>
				<div className={"flex justify-between mt-2"}>
					<Button
						onClick={() => {
							const data: TUserUpdate = {
								username: userData.username,
								email: userData.email,
								password: password.length !== 0 ? password : undefined,
								status: userData.status,
								scope: userData.scope,
								association: userData.association.id,
								role: userData.role,
							};
							api(`/users/${ userData.id}`, {
								method: "PATCH",
								body: data,
							}).then((res) => {
								if (res.status === 200) {
									doReload();
									toast("L'utilisateur à été mis à jour", { type: "success" });
								} else if (res.status === 404) {
									toast(res.message, { type: "warning" });
								} else {
									toast(`Erreur: ${res.message}`, { type: "error" });
								}
							});
						}}
					>
						Sauvegarder
					</Button>
					<ButtonDanger
						onClick={() => {
							if (confirm) {
								api(`/users/${user.data?.id}`, {
									method: "DELETE",
									if: user.data !== undefined,
								}).then((res) => {
									if (res.status === 204) {
										toast("Utilisateur supprimé", { type: "success" });
										navigate("/users");
										setConfirm(false);
									} else {
										toast(res.message, { type: "error" });
									}
								});
							} else {
								setConfirm(true);
								setTimeout(() => {
									setConfirm(false);
								}, 5000);
							}
						}}
					>
						{ confirm ? "Confirmer" : "Supprimer l'utilisateur" }
					</ButtonDanger>
				</div>
			</Card>
			<ListUserJourney/>
		</div>
	);
}
