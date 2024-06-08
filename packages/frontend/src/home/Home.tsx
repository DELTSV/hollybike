import { Card } from "../components/Card/Card.tsx";
import {
	api, useApi,
} from "../utils/useApi.ts";
import { TOnboarding } from "../types/TOnboarding.ts";
import { CheckBox } from "../components/CheckBox.tsx";
import {
	useEffect, useState,
} from "preact/hooks";
import { equals } from "../utils/equals.ts";
import { Link } from "react-router-dom";
import { useUser } from "../user/useUser.tsx";

export function Home() {
	const onboarding = useApi<TOnboarding>("/associations/me/onboarding", []);
	const user = useUser();
	const [localOnboarding, setLocalOnboarding] = useState<TOnboarding | undefined>(onboarding.data);

	useEffect(() => {
		setLocalOnboarding(onboarding.data);
	}, [setLocalOnboarding, onboarding]);

	useEffect(() => {
		if (!equals(localOnboarding, onboarding.data) && localOnboarding !== undefined) {
			api<TOnboarding>("/associations/me/onboarding", {
				method: "PATCH",
				body: localOnboarding,
			}).then((res) => {
				if (res.status === 400) {
					setLocalOnboarding(onboarding.data);
				}
			});
		}
	}, [
		localOnboarding,
		onboarding,
		setLocalOnboarding,
	]);

	return (
		<div>
			{ onboarding.data &&
				<Card>
					<h1>Mon onboarding</h1>
					<div>
						<p className={"flex items-center gap-2"}>
							<CheckBox
								checked={localOnboarding?.update_default_user}
								toggle={() => setLocalOnboarding((prev) => {
									if (prev === undefined) {
										return prev;
									} else {
										return {
											...prev,
											update_default_user: !prev.update_default_user,
										};
									}
								})}
							/>
							<Link to={`/users/${ user.user?.id}`}>Mettre à jour l'utilisateur par défaut</Link>
						</p>
						<p className={"flex items-center gap-2"}>
							<CheckBox
								checked={localOnboarding?.update_association}
								toggle={() => setLocalOnboarding((prev) => {
									if (prev === undefined) {
										return prev;
									} else {
										return {
											...prev,
											update_association: !prev.update_association,
										};
									}
								})}
							/>
							<Link to={`/associations/${ user.user?.association?.id}`}><span>Personnaliser l'association</span></Link>
						</p>
						<p className={"flex items-center gap-2"}>
							<CheckBox
								checked={localOnboarding?.create_invitation}
								toggle={() => setLocalOnboarding((prev) => {
									if (prev === undefined) {
										return undefined;
									} else {
										return {
											...prev,
											create_invitation: !prev.create_invitation,
										};
									}
								})}
							/>
							<Link to={`associations/${ user.user?.association.id }/invitations/`}>
								<span>Créer une invitation</span>
							</Link>
						</p>
					</div>
				</Card> }
		</div>
	);
}
