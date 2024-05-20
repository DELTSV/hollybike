import {
Button, ButtonProps,
} from "./Button.tsx";

export function ButtonDanger(props: ButtonProps) {
	return (
		<Button {...props} className={"!border-red-500 text-red-500 hover:!bg-red-500 hover:!text-white"}>
				{ props.children }
		</Button>
	);
}
