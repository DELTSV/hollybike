import { ComponentChildren } from "preact";
import { clsx } from "clsx";

export interface ButtonProps {
	onClick: (e: MouseEvent) => void,
	children: ComponentChildren,
	className?: string,
}

export function Button(props: ButtonProps) {
	return (
		<button
			onClick={props.onClick} className={
				clsx(
					"px-4 py-2 rounded border-2 border-slate-950 dark:border-slate-100 "
					+ "transition-transform cursor-pointer bg-transparent "
					+ "hover:scale-105 hover:text-slate-100 dark:hover:text-slate-950 "
					+ "hover:bg-slate-950 dark:hover:bg-slate-100",
					props.className,
				)
			}
		>
			{ props.children }
		</button>
	);
}
