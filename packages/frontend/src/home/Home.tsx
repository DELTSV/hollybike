import { useCallback } from "preact/hooks";
import { useAuth } from "../auth/context.tsx";

export function Home() {
	const auth = useAuth();

	const disconnect = useCallback(() => {
		auth.disconnect();
	}, [auth]);

	return (
		<button onClick={disconnect}>Se déconnecter</button>
	);
}
