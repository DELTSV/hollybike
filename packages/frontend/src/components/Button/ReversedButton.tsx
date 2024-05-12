import {
	Button, ButtonProps,
} from "./Button.tsx";
import { clsx } from "clsx";

export function ReversedButton(props: ButtonProps) {
	return (
		<Button {...props} className={clsx("reversed", props.className)}>
			{ props.children }
		</Button>
	);
}
