import { ComponentChildren } from "preact";
import { useState } from "preact/hooks";
import type { ConnectionDTO, LoginDTO } from "../types";
import { Auth } from "../context.tsx";

type Props = { children: ComponentChildren }

export const AuthContextProvider = ({ children }: Props) => {
	const [ token, setToken ] = useState<string>();

	const login = (_data: LoginDTO) => setToken("connecter");
	const connect = (_data: ConnectionDTO) => setToken("connecter");

	return (
		<Auth.Provider
			value={{
				token,
				isLoggedIn: !!token,
				login,
				connect,
			}}
		>
			{ children }
		</Auth.Provider>
	);
};
