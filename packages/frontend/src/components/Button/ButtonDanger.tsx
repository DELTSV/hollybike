import {
	Button, ButtonProps,
} from "./Button.tsx";
import { clsx } from "clsx";

export function ButtonDanger(props: ButtonProps) {
	return (
		<Button {...props} className={clsx("!border-red !text-red", props.className)}>
			{ props.children }
		</Button>
	);
}
