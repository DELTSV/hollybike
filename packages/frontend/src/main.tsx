import { render } from "preact";
import { App } from "./app.tsx";
import "./index.css";
import { AuthContextProvider } from "./auth/context.tsx";
import { ThemeContextProvider } from "./theme/context.tsx";

render(
	<AuthContextProvider>
		<ThemeContextProvider>
			<App/>
		</ThemeContextProvider>
	</AuthContextProvider>,
	document.getElementById("app")!,
);
