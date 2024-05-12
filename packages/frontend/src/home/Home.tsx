import { useCallback } from "preact/hooks";
import { useAuth } from "../auth/context.tsx";
import { Card } from "../components/Card/Card.tsx";

export function Home() {
	const auth = useAuth();

	const disconnect = useCallback(() => {
		auth.disconnect();
	}, [auth]);

	return (
		<div>
			<Card>
				Test
			</Card>
			<button onClick={disconnect}>Se déconnecter</button>
		</div>
	);
}
