/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	Button, ButtonProps,
} from "./Button.tsx";
import { clsx } from "clsx";

export function ButtonDanger(props: ButtonProps) {
	return (
		<Button {...props} className={clsx("!bg-red", props.className)}>
			{ props.children }
		</Button>
	);
}
