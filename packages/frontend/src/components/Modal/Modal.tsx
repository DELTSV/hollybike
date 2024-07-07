import { clsx } from "clsx";
import { ComponentChildren } from "preact";
import { Card } from "../Card/Card.tsx";
import { Close } from "@material-ui/icons";

interface ModalProps {
	width?: string,
	children: ComponentChildren,
	visible: boolean,
	setVisible: (visible: boolean | ((prev: boolean) => boolean)) => void,
	title?: string
}

export function Modal(props: ModalProps) {
	return (
		<div
			onClick={() => props.setVisible(false)}
			className={
				clsx(
					"fixed top-0 left-0 w-screen h-screen bg-base/30 flex items-center justify-center",
					props.visible || "hidden",
				)
			}
			style={{ zIndex: 10_000 }}
		>
			<Card
				className={clsx("relative", props.width ?? "w-3/5")} onClick={(e) => {
					e.stopPropagation();
				}}
			>
				<div className={"flex gap-4 justify-between"}>
					<div/>
					<h1 className={"text-lg"}>{ props.title }</h1>
					<button className={"right-2 top-2"} onClick={() => props.setVisible(false)}>
						<Close/>
					</button>
				</div>
				{ props.children }
			</Card>
		</div>
	);
}
