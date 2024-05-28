import { clsx } from "clsx";

interface RedStarProps {
	className?: string;
}

export function RedStar(props: RedStarProps) {
	return (
		<span className={clsx("text-red-500", props.className)}>*</span>
	);
}
