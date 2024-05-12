import { ComponentChildren } from "preact";
import "./DropDown.css";
import {
	useEffect, useState,
} from "preact/hooks";
import { useRef } from "react";
import { Card } from "../Card/Card.tsx";
import { ReversedButton } from "../Button/ReversedButton.tsx";

interface DropDownProps {
	children: ComponentChildren,
	text: ComponentChildren
}

export function DropDown(props: DropDownProps) {
	const [visible, setVisible] = useState(false);
	const container = useRef<HTMLDivElement>(null);

	const handleOut = (e: MouseEvent) => {
		if (
			container.current
			&& !container.current.contains(e.target as Node)
			&& container.current
		)
			setVisible(false);
	};
	useEffect(() => {
		document.addEventListener("mousedown", handleOut);
		return () => {
			document.removeEventListener("mousedown", handleOut);
		};
	}, []);

	return (
		<div className={"dropdown"} ref={container}>
			<ReversedButton onClick={() => setVisible(prev => !prev)}>{ props.text }</ReversedButton>
			{ visible && <Card className={"dropdown-content"}>{ props.children }</Card> }
		</div>
	);
}

export function Divider() {
	return (
		<div className={"divider"}/>
	);
}

interface DropDownElementProps {
	children: ComponentChildren,
	onClick?: (e: MouseEvent) => void
}

export function DropDownElement(props: DropDownElementProps) {
	return (
		<div className={"dropdown-element"} onClick={props.onClick}>
			{ props.children }
		</div>
	);
}
