import { ComponentChildren } from "preact";
import "./Button.css";
import { clsx } from "clsx";

export interface ButtonProps {
	onClick: (e: MouseEvent) => void,
	children: ComponentChildren,
	className?: string,
}

export function Button(props: ButtonProps) {
	return (
		<button onClick={props.onClick} className={clsx("button", props.className)}>
			{ props.children }
		</button>
	);
}
