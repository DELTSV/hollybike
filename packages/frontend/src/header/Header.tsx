import {Theme} from "../theme/context.tsx";
import {
	DropDown,
	DropDownElement,
} from "../components/DropDown/DropDown.tsx";
import {useUser} from "../user/useUser.tsx";
import {useAuth} from "../auth/context.tsx";
import {Link} from "react-router-dom";
import {useMemo} from "preact/hooks";
import {WbSunny, NightsStay, BrightnessAuto} from "@material-ui/icons";
import {ReactElement} from "react";

interface HeaderProps {
	setTheme: (theme: Theme) => void
}

export function Header(props: HeaderProps) {
	const {setTheme} = props;
	const {user} = useUser();
	const {disconnect} = useAuth();

	const dropdownOptions = useMemo<[Theme, ReactElement, string][]>(() => [
		["light", <WbSunny/>, "Clair"],
		["dark", <NightsStay/>, "Sombre"],
		["os", <BrightnessAuto/>, "Système"]],
		[]
	)

	return (
		<header className={"flex justify-between"}>
			<Link to={"/"}><p className={"w-48 bg-black text-white h-full"}>LOGO</p></Link>
			<div className={"flex items-center gap-2 px-3 py-2"}>
				<DropDown text={"Theme"}>
					{dropdownOptions.map(([theme, icon, text], index) =>
						<DropDownElement
							onClick={(e) => {
								e.stopPropagation();
								setTheme(theme);
							}}
							animationOrder={index}
						>
							{icon}
							{text}
						</DropDownElement>
					)}
				</DropDown>
				<DropDown text={user?.username}>
					<DropDownElement onClick={disconnect}>Se déconnecter</DropDownElement>
				</DropDown>
			</div>
		</header>
	);
}
