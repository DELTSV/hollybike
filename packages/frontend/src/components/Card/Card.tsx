import { ComponentChildren } from "preact";
import { clsx } from "clsx";

interface CardProps {
	children: ComponentChildren,
	className?: string,
	onClick?: (e: MouseEvent) => void
}

export function Card(props: CardProps) {
	return (
		<div
			onClick={props.onClick}
			className={clsx("border-2 bg-slate-100 border-slate-300 dark:bg-slate-800 dark:border-slate-700" +
				" rounded hover:shadow transition-shadow px-2 py-1", props.className)}
		>
			{ props.children }
		</div>
	);
}
