import { Theme } from "../theme/context.tsx";
import "./Header.css";
import {
	DropDown, DropDownElement,
} from "../components/DropDown/DropDown.tsx";

interface HeaderProps {
	setTheme: (theme: Theme) => void
}

export function Header(props: HeaderProps) {
	const { setTheme } = props;
	return (
		<header className={"header"}>
			<p>LOGO</p>
			<div className={"left"}>
				<DropDown text={"Theme"}>
					<DropDownElement onClick={() => setTheme("light")}>Clair</DropDownElement>
					<DropDownElement onClick={() => setTheme("dark")}>Sombre</DropDownElement>
					<DropDownElement onClick={() => setTheme("os")}>Système</DropDownElement>
				</DropDown>
				<p>User</p>
			</div>
		</header>
	);
}
