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
import { useUser } from "../user/useUser.tsx";
import { toast } from "react-toastify";

type AuthContext = {
	token?: string;
	isLoggedIn: boolean;
	loading: boolean;
	login: (data: TLogin) => void;
	disconnect: () => void
}

const Auth = createContext<AuthContext>({
	token: undefined,
	isLoggedIn: false,
	loading: true,
	login: _data => void 0,
	disconnect: () => {},
});

export let externalDisconnect = () => {};

export function useAuth() {
	return useContext(Auth);
}

type Props = { children: ComponentChildren }

export const AuthContextProvider = ({ children }: Props) => {
	const [loading, setLoading] = useState<boolean>(false);

	const [token, setToken] = useState<string>();

	const user = useUser();

	useEffect(() => {
		const token = localStorage.getItem("token");
		if (token != null) {
			setToken(token);
			user.fetchUser().then(() => {
				setLoading(false);
			});
		} else {
			setLoading(false);
		}
	}, []);

	const login = (data: TLogin) => {
		api<TAuthInfo>("/auth/login", {
			method: "POST",
			body: data,
			retryIfUnauthorized: false,
		}).then((res) => {
			if (res.status === 200 && res.data) {
				localStorage.setItem("token", res.data.token);
				localStorage.setItem("refreshToken", res.data.refresh_token);
				localStorage.setItem("deviceId", res.data.deviceId);
				localStorage.setItem("refreshing", "false");
				setToken(res.data!.token);
				user.fetchUser();
			} else if (res.status === 404) {
				toast(res.message, { type: "warning" });
			} else if (res.status === 401) {
				toast(res.message, { type: "warning" });
			}
		});
	};

	const disconnect = useCallback(() => {
		localStorage.removeItem("token");
		localStorage.removeItem("refreshToken");
		localStorage.removeItem("deviceId");
		setToken(undefined);
		user.clean();
		document.location.assign("/login");
	}, []);

	externalDisconnect = disconnect;

	return (
		<Auth.Provider
			value={{
				token,
				isLoggedIn: !!token,
				loading: loading,
				login,
				disconnect,
			}}
		>
			{ children }
		</Auth.Provider>
	);
};
