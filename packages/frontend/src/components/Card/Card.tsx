import { ComponentChildren } from "preact";
import "./Card.css";

interface CardProps {
	children: ComponentChildren
}

export function Card(props: CardProps) {
	return (
		<div className={"card"}>
			{ props.children }
		</div>
	);
}
