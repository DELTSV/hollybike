import { ComponentChildren } from "preact";
import {
	useEffect, useState,
} from "preact/hooks";
import { useRef } from "react";
import style from "./DropDown.module.css";
import { KeyboardArrowDown } from "@material-ui/icons";

interface DropDownProps {
	children: ComponentChildren,
	text: ComponentChildren
}

export function DropDown({
							 text,
							 children,
						 }: DropDownProps) {
	const [visible, setVisible] = useState(false);
	const [isClosing, setIsClosing] = useState(false);
	const dropdown = useRef<HTMLDivElement>(null);

	const close = () => {
		setIsClosing(true);
		setTimeout(() => {
			setVisible(false);
			setIsClosing(false);
		}, 300);
	};

	useEffect(() => {
		const handleOut = (e: MouseEvent) => {
			if (
				dropdown.current &&
				!dropdown.current.contains(e.target as Node) &&
				dropdown.current
			) close();
		};

		document.addEventListener("mousedown", handleOut);
		return () => {
			document.removeEventListener("mousedown", handleOut);
		};
	}, []);

	return (
		<section
			ref={dropdown}
			className={style.dropdown}
			onClick={() => visible ? close() : setVisible(true)}
		>
			<header className={style.button}>
				<p>{ text }</p>
				<KeyboardArrowDown/>
			</header>
			<section
				className={`${style.itemsList} ${isClosing && visible ? style.closing : ""} ${!visible ? style.closed : ""}`}
			>
				{ children }
			</section>
		</section>
	);
}

interface DropDownElementProps {
	children: ComponentChildren,
	animationOrder?: number,
	onClick?: (e: MouseEvent) => void,
}

export function DropDownElement({
	onClick, children, animationOrder,
}: DropDownElementProps) {
	return (
		<section
			class={style.item}
			style={`transition-delay: ${(animationOrder ?? 0) * 0.1 + 0.2}s;`}
			onClick={onClick}
		>
			{ children }
		</section>
	);
}
