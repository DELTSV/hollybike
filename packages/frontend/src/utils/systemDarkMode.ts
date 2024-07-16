/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	useEffect, useState,
} from "preact/hooks";

export function useSystemDarkMode() {
	const [darkMode, setDarkMode] = useState(window.matchMedia("(prefers-color-scheme: dark)").matches);
	useEffect(() => {
		const onChange = (e: MediaQueryListEvent) => {
			setDarkMode(e.matches);
		};
		if (window.matchMedia) {
			window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", onChange);
		}

		return () => {
			window.matchMedia("(prefers-color-scheme: dark)").removeEventListener("change", onChange);
		};
	}, []);

	return darkMode;
}
