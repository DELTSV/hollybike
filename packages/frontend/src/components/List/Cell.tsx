/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { ComponentChildren } from "preact";
import { clsx } from "clsx";

interface CellProps {
	children: ComponentChildren,
	key?: string | number,
	className?: string,
	onClick?: () => void
}

export function Cell(props: CellProps) {
	return (
		<td
			onClick={props.onClick} className={clsx(
				"text-center p-2 whitespace-nowrap",
				props.className,
			)}
			key={props.key}
		>
			{ props.children }
		</td>
	);
}
