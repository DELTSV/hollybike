/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { clsx } from "clsx";

interface RedStarProps {
	className?: string;
}

export function RedStar(props: RedStarProps) {
	return (
		<span className={clsx("text-red", props.className)}>*</span>
	);
}
