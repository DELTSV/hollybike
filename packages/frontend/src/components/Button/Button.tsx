import { ComponentChildren } from "preact";
import { clsx } from "clsx";

export interface ButtonProps {
	onClick: (e: MouseEvent) => void,
	children: ComponentChildren,
	className?: string,
	type?: string
}

export function Button(props: ButtonProps) {
	return (
		<button
			type={props.type}
			onClick={props.onClick} className={
				clsx(
					"px-2 py-1 rounded border-2 border-slate-950 dark:border-slate-100" +
					" transition-transform cursor-pointer bg-slate-100 dark:bg-slate-900" +
					" hover:scale-105 hover:text-slate-100 dark:hover:text-slate-950" +
					" hover:bg-slate-950 dark:hover:bg-slate-100",
					props.className,
				)
			}
		>
			{ props.children }
		</button>
	);
}
