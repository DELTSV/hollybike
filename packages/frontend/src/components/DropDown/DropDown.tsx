import { ComponentChildren } from "preact";
import {
	useEffect, useState,
} from "preact/hooks";
import { useRef } from "react";
import { Card } from "../Card/Card.tsx";
import { Button } from "../Button/Button.tsx";

interface DropDownProps {
	children: ComponentChildren,
	text: ComponentChildren
}

export function DropDown({
	text, children,
}: DropDownProps) {
	const [visible, setVisible] = useState(false);
	const container = useRef<HTMLDivElement>(null);


	useEffect(() => {
		const handleOut = (e: MouseEvent) => {
			if (
				container.current &&
				!container.current.contains(e.target as Node) &&
				container.current
			)
				setVisible(false);
		};

		document.addEventListener("mousedown", handleOut);
		return () => {
			document.removeEventListener("mousedown", handleOut);
		};
	}, []);

	return (
		<div className={"relative"} ref={container}>
			<Button onClick={() => setVisible(prev => !prev)}>{ text }</Button>
			{ visible &&
				<Card className={"flex flex-col absolute top-full left-1/2 -translate-x-1/2"}>
					{ children }
				</Card> }
		</div>
	);
}

export function Divider() {
	return (
		<div className={"h-0.5 bg-slate-200 dark:bg-slate-600"}/>
	);
}

interface DropDownElementProps {
	children: ComponentChildren,
	onClick?: (e: MouseEvent) => void
}

export function DropDownElement(props: DropDownElementProps) {
	return (
		<div
			className={"p-2 text-center cursor-pointer hover:bg-slate-300 dark:hover:bg-slate-700 rounded"}
			onClick={props.onClick}
		>
			{ props.children }
		</div>
	);
}
