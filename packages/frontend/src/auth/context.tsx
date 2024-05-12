import {
	ComponentChildren, createContext,
} from "preact";
import type {
	TAuthInfo, TLogin,
} from "./types";
import {
	useCallback, useContext,
	useEffect, useState,
} from "preact/hooks";
import { api } from "../utils/useApi.ts";

type AuthContext = {
	token?: string;
	isLoggedIn: boolean;
	login: (data: TLogin) => void;
	disconnect: () => void
}

const Auth = createContext<AuthContext>({
	token: undefined,
	isLoggedIn: false,
	login: _data => void 0,
	disconnect: () => {},
});

export function useAuth() {
	return useContext(Auth);
}

type Props = { children: ComponentChildren }

export const AuthContextProvider = ({ children }: Props) => {
	const [token, setToken] = useState<string>();

	useEffect(() => {
		const token = localStorage.getItem("token");
		if (token != null)
			setToken(token);
	}, []);

	const login = (data: TLogin) => {
		api<TAuthInfo, TLogin>("/auth/login", {
			method: "POST",
			body: data,
		}).then((res) => {
			if (res.status === 200) {
				localStorage.setItem("token", res.data!.token);
				setToken(res.data!.token);
			} else
				console.log(res.message);
		});
	};

	const disconnect = useCallback(() => {
		localStorage.removeItem("token");
		setToken(undefined);
	}, []);

	return (
		<Auth.Provider
			value={{
				token,
				isLoggedIn: !!token,
				login,
				disconnect,
			}}
		>
			{ children }
		</Auth.Provider>
	);
};
