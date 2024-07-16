/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	ComponentChildren, createContext,
} from "preact";
import {
	useContext, useEffect, useState,
} from "preact/hooks";
import { useApi } from "./useApi.ts";
import { useReload } from "./useReload.ts";
import { TConfDone } from "../types/GConfDone.ts";

interface ConfModeContext {
	confMode?: boolean,
	reloadConfMode: () => void
}

const ConfMode = createContext<ConfModeContext>({
	confMode: undefined,
	reloadConfMode: () => {},
});

export const useConfMode = () => useContext(ConfMode);

interface ConfModeProviderProps {
	children: ComponentChildren
}

export function ConfModeProvider(props: ConfModeProviderProps) {
	const [confMode, setConfMode] = useState<boolean>();

	const {
		reload, doReload,
	} = useReload();

	const apiConfMode = useApi<TConfDone>("/conf-done", [reload]);

	useEffect(() => {
		if (apiConfMode.status === 200 && apiConfMode.data) {
			setConfMode(apiConfMode.data.conf_done);
		} else {
			setConfMode(undefined);
		}
	}, [apiConfMode, setConfMode]);

	return (
		<ConfMode.Provider
			value={{
				confMode,
				reloadConfMode: doReload,
			}}
		>
			{ props.children }
		</ConfMode.Provider>
	);
}
