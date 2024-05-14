import { render } from "preact";
import { App } from "./app.tsx";
import "./index.css";
import { AuthContextProvider } from "./auth/context.tsx";
import { ThemeContextProvider } from "./theme/context.tsx";
import { UserProvider } from "./user/useUser.tsx";

render(
	<UserProvider>
		<AuthContextProvider>
			<ThemeContextProvider>
				<App/>
			</ThemeContextProvider>
		</AuthContextProvider>
	</UserProvider>,
	document.getElementById("app")!,
);
