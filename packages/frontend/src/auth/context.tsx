import {
	ComponentChildren, createContext,
} from "preact";
import type {
	ConnectionDTO, LoginDTO,
} from "./types";
import { useState } from "preact/hooks";

type AuthContext = {
    token?: string;
    isLoggedIn: boolean;
    login: (data: LoginDTO) => void;
    connect: (data: ConnectionDTO) => void;
}

export const Auth = createContext<AuthContext>({
	token: undefined,
	isLoggedIn: false,
	login: _data => void 0,
	connect: _data => void 0,
});

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
