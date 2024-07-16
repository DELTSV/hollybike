/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { render } from "preact";
import { App } from "./app.tsx";
import "./index.css";
import { AuthContextProvider } from "./auth/context.tsx";
import { ThemeContextProvider } from "./theme/context.tsx";
import { UserProvider } from "./user/useUser.tsx";
import { SideBarProvider } from "./sidebar/useSideBar.tsx";
import { ConfModeProvider } from "./utils/useConfMode.tsx";

render(
	<UserProvider>
		<AuthContextProvider>
			<ThemeContextProvider>
				<SideBarProvider>
					<ConfModeProvider>
						<App/>
					</ConfModeProvider>
				</SideBarProvider>
			</ThemeContextProvider>
		</AuthContextProvider>
	</UserProvider>,
	document.getElementById("app")!,
);
