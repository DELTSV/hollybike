import { ComponentChildren } from "preact";
import { clsx } from "clsx";
import {
	ArrowDropDown, ArrowDropUp,
} from "@material-ui/icons";
import { useCallback } from "preact/hooks";

export interface Sort {
	column: string,
	order: "asc" | "desc" | "none"
}

interface HeadProps {
	children: ComponentChildren,
	key?: string | number
	className?: string,
	sortable?: boolean,
	sort?: Sort,
	setSortOrder?: (order: "asc" | "desc" | "none") => void,
	width?: string
}

export function Head(props: HeadProps) {
	const onClick = useCallback(() => {
		if (props.sortable && props.setSortOrder) {
			if (props.sort?.order === "asc") {
				props.setSortOrder("desc");
			} else if (props.sort?.order === "desc") {
				props.setSortOrder("none");
			} else {
				props.setSortOrder("asc");
			}
		}
	}, [
		props.setSortOrder,
		props.sort,
		props.sortable,
	]);
	return (
		<th
			className={
				clsx("text-center px-2 py-1", props.sortable && props.sort && props.setSortOrder && "cursor-pointer")
			} onClick={onClick}
			style={{ width: props.width ?? "auto" }}
		>
			{ props.children }
			{ props.sortable &&
				( props.sort?.order === "asc" ? <ArrowDropUp/> : props.sort?.order === "desc" && <ArrowDropDown/> ) }
		</th>
	);
}
