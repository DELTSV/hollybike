import { useNavigate } from "react-router-dom";
import { ComponentChildren } from "preact";

interface SideBarMenuProps {
	to: string,
	children: ComponentChildren
}

export function SideBarMenu(props: SideBarMenuProps) {
	const navigate = useNavigate();

	return (
		<a
			className={
				"m-2 rounded py-1 px-2 transition-colors cursor-pointer hover:bg-slate-300 dark:hover:bg-slate-800"
			}
			onClick={() => navigate(props.to)}
		>
			{ props.children }
		</a>
	);
}
