/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	ComponentChildren, JSX,
} from "preact";

interface TextAreaProps {
	children?: ComponentChildren
	value?: string,
	onInput?: (e: JSX.TargetedEvent<HTMLTextAreaElement>) => void,
	placeHolder?: string
}

export function TextArea(props: TextAreaProps) {
	return (
		<textarea
			className={"rounded border-2 border-surface-1 bg-mantle p-2"}
			value={props.value} onInput={props.onInput}
			placeholder={props.placeHolder}
		>
			{ props.children }
		</textarea>
	);
}
