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
					"px-2 py-1 rounded border-2 transition-transform bg-surface-0 flex items-center gap-4",
					props.className,
					disabled ? "cursor-default border-overlay-0 text-subtext-0" :
						"cursor-pointer hover:scale-105 text-subtext-1 border-lavender"
					,
				)
			}
		>
			{ props.children }
			{ props.loading === true && <div className={"border-2 rounded-full h-4 w-4 animate-spin border-b-transparent"}/> }
		</button>
	);
}
