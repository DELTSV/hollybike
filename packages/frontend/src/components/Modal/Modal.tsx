/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { clsx } from "clsx";
import { ComponentChildren } from "preact";
import { Card } from "../Card/Card.tsx";
import { CloseRounded } from "@material-ui/icons";

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
					"fixed top-0 left-0 w-screen h-screen flex items-center justify-center",
					"transition-backdrop-filter-bg duration-200 cursor-pointer",
					props.visible ?
						clsx(
							"bg-crust/40 backdrop-blur-sm pointer-events-auto",
							"[&:hover:not(:has(:hover))]:bg-crust/10 [&:hover:not(:has(:hover))]:backdrop-blur-[1px]",
						) :
						"!bg-none backdrop-blur-0 pointer-events-none",
				)
			}
			style={{ zIndex: 10_000 }}
		>
			<Card
				className={clsx(
					props.width ?? "w-3/5",
					"relative pointer-events-auto cursor-auto",
					"transition-transform duration-100",
					props.visible ? "translate-y-0" : "translate-y-[100vh]",
				)} onClick={(e) => {
					e.stopPropagation();
				}}
			>
				<div className={"flex gap-4 justify-between"}>
					<h1 className={"text-lg"}>{ props.title }</h1>
					<button
						className={clsx(
							"bg-subtext-1 text-base fill-base rounded p-1",
							"w-8 [&:has(svg:hover)]:w-24",
							"transition-w duration-200 group",
							"flex justify-end gap-1",
						)}
						onClick={() => props.setVisible(false)}
					>
						<p
							className={clsx(
								"translate-y-4 -translate-x-4 opacity-0",
								"transition-transform-opacity duration-200",
								"group-[&:has(svg:hover)]:translate-y-0",
								"group-[&:has(svg:hover)]:translate-x-0",
								"group-[&:has(svg:hover)]:opacity-100",
							)}
						>
							Fermer
						</p>
						<CloseRounded/>
					</button>
				</div>
				{ props.children }
			</Card>
		</div>
	);
}
