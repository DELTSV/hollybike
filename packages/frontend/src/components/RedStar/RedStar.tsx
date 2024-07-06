import { clsx } from "clsx";

interface RedStarProps {
	className?: string;
}

export function RedStar(props: RedStarProps) {
	return (
		<span className={clsx("text-red", props.className)}>*</span>
	);
}
