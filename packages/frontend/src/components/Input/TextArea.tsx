import {
	ComponentChildren, JSX,
} from "preact";

interface TextAreaProps {
	children?: ComponentChildren
	value?: string,
	onInput?: (e: JSX.TargetedEvent<HTMLTextAreaElement>) => void,
}

export function TextArea(props: TextAreaProps) {
	return (
		<textarea
			className={"rounded border-2 border-slate-700 bg-slate-100 dark:bg-slate-800"}
			value={props.value} onInput={props.onInput}
		>
			{ props.children }
		</textarea>
	);
}
