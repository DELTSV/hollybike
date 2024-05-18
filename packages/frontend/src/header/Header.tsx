import { Theme } from "../theme/context.tsx";
import {
	Divider,
	DropDown, DropDownElement,
} from "../components/DropDown/DropDown.tsx";
import { useUser } from "../user/useUser.tsx";
import { useAuth } from "../auth/context.tsx";
import { Link } from "react-router-dom";

interface HeaderProps {
	setTheme: (theme: Theme) => void
}

export function Header(props: HeaderProps) {
	const { setTheme } = props;
	const { user } = useUser();
	const { disconnect } = useAuth();
	return (
		<header className={"flex justify-between"}>
			<Link to={"/"}><p className={"w-48 bg-black text-white h-full"}>LOGO</p></Link>
			<div className={"flex items-center gap-2 px-3 py-2"}>
				<DropDown text={"Theme"}>
					<DropDownElement onClick={() => setTheme("light")}>Clair</DropDownElement>
					<DropDownElement onClick={() => setTheme("dark")}>Sombre</DropDownElement>
					<Divider/>
					<DropDownElement onClick={() => setTheme("os")}>Système</DropDownElement>
				</DropDown>
				<DropDown text={user?.username}>
					<DropDownElement onClick={disconnect}>Se déconnecter</DropDownElement>
				</DropDown>
			</div>
		</header>
	);
}
