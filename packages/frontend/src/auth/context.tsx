import { createContext } from "preact";
import type { ConnectionDTO, LoginDTO } from "./types";

export type AuthContext = {
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
