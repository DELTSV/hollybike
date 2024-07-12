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
			className={clsx(
				"bg-base rounded-xl hover:shadow transition-shadow p-4",
				props.className,
			)}
		>
			{ props.children }
		</div>
	);
}
