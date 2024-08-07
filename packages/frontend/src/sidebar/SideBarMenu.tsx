/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	Link,
	useLocation,
} from "react-router-dom";
import { ComponentChildren } from "preact";
import { clsx } from "clsx";

interface SideBarMenuProps {
	to: string,
	children: ComponentChildren,
	indent?: boolean
}

export function SideBarMenu(props: SideBarMenuProps) {
	const location = useLocation();

	return (
		<Link
			className={clsx(
				"rounded py-1 px-2 transition-colors cursor-pointer hover:bg-surface-0",
				location.pathname === props.to && "bg-surface-1",
				props.indent === true && "ml-2",
			)}
			to={props.to}
		>
			{ props.children }
		</Link>
	);
}
