import {
	ComponentChildren, JSX,
} from "preact";
import { clsx } from "clsx";

interface InputProps {
	onInput: (e: JSX.TargetedEvent<HTMLInputElement>) => void,
	value: string,
	type?: string,
	placeholder?: string,
	className?: string,
	icon?: ComponentChildren
}

export function Input(props: InputProps) {
	return (
		<div
			className={clsx("bg-slate-100 dark:bg-slate-800 rounded flex", props.className)}
		>
			{ props.icon &&
			<i
				className={"h-full flex items-center border-2 border-slate-950 dark:border-slate-700 rounded-l p-1"}
			>
				{ props.icon }
			</i> }
			<input
				value={props.value} onInput={props.onInput} type={props.type} placeholder={props.placeholder}
				className={clsx("w-full h-full py-2 px-2 bg-transparent rounded" +
					" focus-visible:outline-blue-500 border-slate-950" +
					" dark:focus-visible:outline-blue-700 outline-2 focus-visible:-outline-offset-1 focus-visible:outline" +
					" rounded border-2 dark:border-slate-700", props.icon && "border-l-0 rounded-l-none")}
			/>
		</div>
	);
}
