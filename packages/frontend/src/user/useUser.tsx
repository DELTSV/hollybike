import {
	ComponentChildren, createContext,
} from "preact";
import { TUser } from "../types/TUser.ts";
import {
	useCallback,
	useContext, useState,
} from "preact/hooks";
import { api } from "../utils/useApi.ts";
import { TUpdatePassword } from "../types/TUpdatePassword.ts";

interface UserContext {
	user: TUser | null,
	fetchUser: () => Promise<TUser | null>,
	setUsername: (username: string) => void,
	setPassword: (passwordChange: TUpdatePassword) => void,
	clean: () => void
}

const User = createContext<UserContext>({
	user: null,
	fetchUser: async () => null,
	setUsername: (_username: string) => {},
	setPassword: (_passwordChange: TUpdatePassword) => {},
	clean: () => {},
});

export const useUser = () => useContext(User);

interface UserProviderProps {
	children: ComponentChildren
}

export function UserProvider(props: UserProviderProps) {
	const [user, setUser] = useState<TUser | null>(null);

	const setUsername = useCallback((username: string) => {
		api<TUser>("/users/me", {
			method: "PATCH",
			body: { username: username },
		}).then((res) => {
			if (res.status === 200)
				setUser(res.data!);
		});
	}, []);

	const setPassword = useCallback((passwordChange: TUpdatePassword) => {
		api<TUser>("/users/me", {
			method: "PATCH",
			body: passwordChange,
		}).then((res) => {
			if (res.status === 200)
				setUser(res.data!);
		});
	}, []);

	const fetchUser = useCallback(async () => {
		const res = await api<TUser>("/users/me");
		if (res.status === 200) {
			setUser(res.data!);
			return res.data!;
		}
		return null;
	}, []);

	const clean = useCallback(() => {
		setUser(null);
	}, []);

	return (
		<User.Provider
			value={{
				user: user,
				setUsername: setUsername,
				setPassword: setPassword,
				fetchUser: fetchUser,
				clean,
			}}
		>
			{ props.children }
		</User.Provider>
	);
}
