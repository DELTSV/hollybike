import { render } from "preact";
import { App } from "./app.tsx";
import "./index.css";
import { AuthContextProvider } from "./auth/context.tsx";
import { ThemeContextProvider } from "./theme/context.tsx";
import { UserProvider } from "./user/useUser.tsx";
import { SideBarProvider } from "./sidebar/useSideBar.tsx";

render(
	<UserProvider>
		<AuthContextProvider>
			<ThemeContextProvider>
				<SideBarProvider>
					<App/>
				</SideBarProvider>
			</ThemeContextProvider>
		</AuthContextProvider>
	</UserProvider>,
	document.getElementById("app")!,
);
