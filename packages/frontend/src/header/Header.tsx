import { Theme } from "../theme/context.tsx";
import {
	DropDown,
	DropDownElement,
} from "../components/DropDown/DropDown.tsx";
import { useUser } from "../user/useUser.tsx";
import { useAuth } from "../auth/context.tsx";
import { useMemo } from "preact/hooks";
import {
	WbSunny, NightsStay, BrightnessAuto, Menu,
} from "@material-ui/icons";
import { ReactElement } from "react";
import { useSideBar } from "../sidebar/useSideBar.tsx";
import "./Header.css";
import { clsx } from "clsx";

interface HeaderProps {
	setTheme: (theme: Theme) => void
}

export function Header(props: HeaderProps) {
	const { setTheme } = props;
	const { user } = useUser();
	const { disconnect } = useAuth();
	const { setVisible } = useSideBar();

	const dropdownOptions = useMemo<[Theme, ReactElement, string][]>(
		() => [
			[
				"light",
				<WbSunny/>,
				"Clair",
			],
			[
				"dark",
				<NightsStay/>,
				"Sombre",
			],
			[
				"os",
				<BrightnessAuto/>,
				"Système",
			],
		],
		[],
	);

	return (
		<header className={"flex justify-between md:justify-end items-center gap-4"}>
			<button
				className={clsx(
					"visible md:!hidden",
					"bg-subtext-1 text-base fill-base rounded p-1",
					"origin-top-left md:scale-0 md:-mb-10",
					"transition-transform-w duration-200",
					"flex gap-1 items-center h-8 w-8 hover:w-[7.5rem]",
					"group overflow-clip",
				)}
				onClick={() => setVisible(true)}
			>
				<Menu/>
				<p
					className={clsx(
						"translate-x-4 translate-y-4 opacity-0",
						"transition-transform duration-200",
						"group-hover:translate-x-0 group-hover:translate-y-0 group-hover:opacity-100",
					)}
				>
					Navigation
				</p>
			</button>
			<div className={"flex items-center gap-2"}>
				<DropDown text={"Theme"}>
					{ dropdownOptions.map(([
											  theme,
											  icon,
											  text,
										  ], index) =>
						<DropDownElement
							onClick={(e) => {
								e.stopPropagation();
								setTheme(theme);
							}}
							animationOrder={index}
						>
							{ icon }
							{ text }
						</DropDownElement>) }
				</DropDown>
				<DropDown text={user?.username}>
					<DropDownElement onClick={disconnect}>Se déconnecter</DropDownElement>
				</DropDown>
			</div>
		</header>
	);
}
