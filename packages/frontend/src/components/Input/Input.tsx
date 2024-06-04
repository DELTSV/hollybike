import {
	ComponentChildren, JSX,
} from "preact";
import { clsx } from "clsx";
import {
	ForwardedRef, forwardRef,
} from "react";

interface InputProps {
	onInput?: (e: JSX.TargetedEvent<HTMLInputElement>) => void,
	onFocusIn?: (e: JSX.TargetedEvent<HTMLInputElement>) => void,
	onFocusOut?: (e: JSX.TargetedEvent<HTMLInputElement>) => void,
	value: string,
	type?: string,
	placeholder?: string,
	className?: string,
	leftIcon?: ComponentChildren
	rightIcon?: ComponentChildren,
}

export const Input = forwardRef((props: InputProps, ref: ForwardedRef<HTMLDivElement>) =>
	<div
		ref={ref}
		className={clsx("bg-slate-100 dark:bg-slate-800 rounded flex items-stretch", props.className)}
	>
		{ props.leftIcon &&
			<i className={"flex items-center border-2 border-slate-950 dark:border-slate-700 rounded-l p-1"}>
				{ props.leftIcon }
			</i> }
		<input
			onFocusIn={props.onFocusIn} onFocusOut={props.onFocusOut}
			value={props.value} onInput={props.onInput} type={props.type} placeholder={props.placeholder}
			className={clsx(
				"w-full h-full py-2 px-2 bg-transparent rounded" +
					" focus-visible:outline-blue-500 border-slate-950" +
					" dark:focus-visible:outline-blue-700 outline-2 focus-visible:-outline-offset-1 focus-visible:outline" +
					" rounded border-2 dark:border-slate-700",
				props.leftIcon && "border-l-0 rounded-l-none",
				props.rightIcon && "border-r-0 rounded-r-none",
			)}
		/>
		{ props.rightIcon &&
			<i className={"flex items-center border-2 border-slate-950 dark:border-slate-700 rounded-r p-1"}>
				{ props.rightIcon }
			</i> }
	</div>);
