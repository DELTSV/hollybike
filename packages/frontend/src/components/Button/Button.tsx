import { ComponentChildren } from "preact";
import { clsx } from "clsx";
import { useMemo } from "preact/hooks";

export interface ButtonProps {
	onClick: (e: MouseEvent) => void,
	children: ComponentChildren,
	className?: string,
	type?: string,
	loading?: boolean,
	disabled?: boolean
}

export function Button(props: ButtonProps) {
	const disabled = useMemo(() => props.disabled === true || props.loading === true, [props.disabled, props.loading]);
	return (
		<button
			disabled={disabled}
			type={props.type}
			onClick={props.onClick} className={
				clsx(
					"px-2 py-1 rounded border-2 border-slate-950 dark:border-slate-100",
					"transition-transform bg-slate-100 dark:bg-slate-900",
					"flex items-center gap-4",
					props.className,
					disabled ? "cursor-default" :
						"cursor-pointer hover:scale-105 hover:text-slate-100 dark:hover:text-slate-950" +
						" hover:bg-slate-950 dark:hover:bg-slate-100 "
					,
					props.disabled && "!border-slate-400 dark:!border-slate-400 !text-slate-400 dark:!text-slate-400",
				)
			}
		>
			{ props.children }
			{ props.loading === true && <div className={"border-2 rounded-full h-4 w-4 animate-spin border-b-transparent"}/> }
		</button>
	);
}
