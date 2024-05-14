import {
	ComponentChildren, createContext,
} from "preact";
import {
	useCallback,
	useContext, useEffect, useState,
} from "preact/hooks";

export type Theme = "os" | "light" | "dark"

interface ThemeContext {
	theme: Theme,
	set: (theme: Theme) => void,
}

const Theme = createContext<ThemeContext>( {
	theme: "os",
	set: (_theme: Theme) => {},
} );

export function useTheme() {
	return useContext(Theme);
}

interface ThemeProps {
	children: ComponentChildren
}

export function ThemeContextProvider(props: ThemeProps) {
	const [theme, setTheme] = useState<Theme>("os");

	useEffect(() => {
		const localTheme = localStorage.getItem("theme");
		if (localTheme !== null)
			setTheme(localTheme as Theme);
	}, []);

	const set = useCallback((theme: Theme) => {
		setTheme(theme);
		localStorage.setItem("theme", theme);
	}, []);

	return (
		<Theme.Provider
			value={{
				theme,
				set,
			}}
		>
			{ props.children }
		</Theme.Provider>
	);
}
