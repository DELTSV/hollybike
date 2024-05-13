import {
	useLocation, useNavigate,
} from "react-router-dom";
import { ComponentChildren } from "preact";
import { clsx } from "clsx";

interface SideBarMenuProps {
	to: string,
	children: ComponentChildren
}

export function SideBarMenu(props: SideBarMenuProps) {
	const navigate = useNavigate();

	const location = useLocation();

	return (
		<a
			className={clsx("m-2 rounded py-1 px-2 transition-colors cursor-pointer" +
			" hover:bg-slate-300 dark:hover:bg-slate-800", location.pathname === props.to && "bg-slate-300 dark:bg-slate-800")}
			onClick={() => navigate(props.to)}
		>
			{ props.children }
		</a>
	);
}
