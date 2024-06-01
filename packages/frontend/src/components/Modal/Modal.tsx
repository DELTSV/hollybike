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
	if (props.visible)
		return (
			<div
				onClick={() => props.setVisible(false)}
				className={"fixed top-0 left-0 w-screen h-screen bg-slate-100/60" +
					" dark:bg-slate-800/60 flex items-center justify-center"}
			>
				<Card
					className={clsx("relative", props.width ?? "w-3/5")} onClick={(e) => {
						e.preventDefault();
						e.stopPropagation();
					}}
				>
					<div className={"flex gap-4 justify-between"}>
						<div/>
						<h1 className={"text-lg"}>{ props.title }</h1>
						<button className={"right-2 top-2"}>
							<Close/>
						</button>
					</div>
					{ props.children }
				</Card>
			</div>
		);
	else
		return null;
}
