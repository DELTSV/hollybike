import { ComponentChildren } from "preact";
import { clsx } from "clsx";

interface CardProps {
	children: ComponentChildren,
	className?: string
}

export function Card(props: CardProps) {
	return (
		<div className={clsx("bg-slate-800 border-2 border-slate-700 rounded-lg", props.className)}>
			{ props.children }
		</div>
	);
}
