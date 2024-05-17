import { ComponentChildren } from "preact";
import { clsx } from "clsx";

interface CellProps {
	children: ComponentChildren,
	key?: string | number,
	className?: string
}

export function Cell(props: CellProps) {
	return (
		<td className={clsx("text-center px-2 py-1", props.className)} key={props.key}>
			{ props.children }
		</td>
	);
}
