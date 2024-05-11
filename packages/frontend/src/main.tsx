import { render } from "preact";
import { App } from "./app.tsx";
import "./index.css";
import { AuthContextProvider } from "./auth/context.tsx";

render(
	<AuthContextProvider>
		<App/>
	</AuthContextProvider>,
	document.getElementById("app")!,
);
