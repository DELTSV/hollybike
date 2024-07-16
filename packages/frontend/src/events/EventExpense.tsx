/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Card } from "../components/Card/Card.tsx";
import { TExpense } from "../types/TExpense.ts";
import { Button } from "../components/Button/Button.tsx";
import {
	Dispatch, StateUpdater, useState,
} from "preact/hooks";
import { Modal } from "../components/Modal/Modal.tsx";
import { dateToFrenchString } from "../components/Calendar/InputCalendar.tsx";

import { DoReload } from "../utils/useReload.ts";
import {
	EditOutlined,
	KeyboardArrowDown, VisibilityOutlined,
} from "@material-ui/icons";
import { clsx } from "clsx";
import { ExpenseEditAddModal } from "./ExpenseEditAddModal.tsx";

interface EventExpenseProps {
	expenses: TExpense[],
	eventId: number,
	doReload: DoReload
}

export function EventExpense(props: EventExpenseProps) {
	const {
		expenses, eventId, doReload,
	} = props;
	const [display, setDisplay] = useState(false);
	const [type, setType] = useState<"add" | "edit">("add");
	const [data, setData] = useState<TExpense>();
	return (
		<Card className={"grow-[1] overflow-hidden flex flex-col"}>
			<div className={"flex justify-between items-center"}>
				Dépense
				<Button
					onClick={() => {
						setDisplay(true);
						setType("add");
					}}
				>
					Ajouter
				</Button>
			</div>
			<div className={"overflow-auto"}>
				{ expenses.map((expense, index) =>
					<Expense
						expense={expense}
						key={index}
						setEditModalVisibility={setDisplay}
						setData={setData}
						setType={setType}
					/>) }
			</div>
			<ExpenseEditAddModal
				type={type}
				setData={setData}
				visible={display}
				setVisible={setDisplay}
				eventId={eventId}
				doReload={doReload}
				data={data}
			/>
		</Card>
	);
}

interface ExpenseProps {
	expense: TExpense,
	setEditModalVisibility: Dispatch<StateUpdater<boolean>>,
	setData: Dispatch<StateUpdater<TExpense | undefined>>,
	setType: Dispatch<StateUpdater<"add" | "edit">>
}

function Expense(props: ExpenseProps) {
	const [visible, setVisible] = useState(false);
	const [modal, setModal] = useState(false);
	return (
		<div className={"cursor-pointer overflow-hidden"} onClick={() => setVisible(!visible)}>
			<div className={"flex justify-between"}>
				<div className={"flex gap-2 items-center"}>
					<p>{ props.expense.name }</p>
					<p className={"text-sm text-subtext-0"}>{ (props.expense.amount / 100).toFixed(2) } €</p>
					<p>{ dateToFrenchString(props.expense.date) }</p>
				</div>
				<KeyboardArrowDown className={clsx("!transition", visible && "rotate-180" || "rotate-0")}/>
			</div>
			<div className={clsx("transition-all overflow-hidden flex justify-between", visible && "max-h-20" || "max-h-0")}>
				<p>{ props.expense.description }</p>
				<div className={"flex"}>
					<EditOutlined
						onClick={(e) => {
							props.setEditModalVisibility(true);
							props.setData(props.expense);
							props.setType("edit");
							e.stopPropagation();
						}}
					/>
					{ props.expense.proof && <VisibilityOutlined
						onClick={(e) => {
							setModal(true);
							e.stopPropagation();
						}}
					/> }
				</div>
			</div>
			<Modal visible={modal} setVisible={setModal}>
				<img alt={"Preuve d'achat"} src={props.expense.proof}/>
			</Modal>
		</div>
	);
}
