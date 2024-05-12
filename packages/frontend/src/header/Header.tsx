import { Theme } from "../theme/context.tsx";
import "./Header.css";
import {
	DropDown, DropDownElement,
} from "../components/DropDown/DropDown.tsx";
import { useUser } from "../user/useUser.tsx";
import { useAuth } from "../auth/context.tsx";

interface HeaderProps {
	setTheme: (theme: Theme) => void
}

export function Header(props: HeaderProps) {
	const { setTheme } = props;
	const { user } = useUser();
	const { disconnect } = useAuth();
	return (
		<header className={"header"}>
			<p>LOGO</p>
			<div className={"left"}>
				<DropDown text={"Theme"}>
					<DropDownElement onClick={() => setTheme("light")}>Clair</DropDownElement>
					<DropDownElement onClick={() => setTheme("dark")}>Sombre</DropDownElement>
					<DropDownElement onClick={() => setTheme("os")}>Système</DropDownElement>
				</DropDown>
				<DropDown text={user?.username}>
					<DropDownElement onClick={disconnect}>Se déconnecter</DropDownElement>
				</DropDown>
			</div>
		</header>
	);
}
