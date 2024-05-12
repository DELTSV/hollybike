import { ComponentChildren } from "preact";
import "./Card.css";
import { clsx } from "clsx";

interface CardProps {
	children: ComponentChildren,
	className?: string
}

export function Card(props: CardProps) {
	return (
		<div className={clsx("card", props.className)}>
			{ props.children }
		</div>
	);
}
