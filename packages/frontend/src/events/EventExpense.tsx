import { Card } from "../components/Card/Card.tsx";
import { TExpense } from "../types/TExpense.ts";
import { Button } from "../components/Button/Button.tsx";
import { useState } from "preact/hooks";
import { Modal } from "../components/Modal/Modal.tsx";
import { Input } from "../components/Input/Input.tsx";
import { TextArea } from "../components/Input/TextArea.tsx";
import {
	dateToFrenchString, InputCalendar,
} from "../components/Calendar/InputCalendar.tsx";
import { RedStar } from "../components/RedStar/RedStar.tsx";
import { api } from "../utils/useApi.ts";
import { DoReload } from "../utils/useReload.ts";
import { KeyboardArrowDown } from "@material-ui/icons";
import { clsx } from "clsx";
import { toast } from "react-toastify";

interface EventExpenseProps {
	expenses: TExpense[],
	eventId: number,
	doReload: DoReload
}

export function EventExpense(props: EventExpenseProps) {
	const {
		expenses, eventId, doReload,
	} = props;
	const [displayAdd, setDisplayAdd] = useState(false);
	const [name, setName] = useState("");
	const [description, setDescription] = useState<string>();
	const [date, setDate] = useState<Date | undefined>(new Date());
	const [amount, setAmount] = useState("");
	return (
		<Card className={"grow"}>
			<div className={"flex justify-between items-center"}>
				Dépense
				<Button onClick={() => setDisplayAdd(true)}>Ajouter</Button>
			</div>
			<div>
				{ expenses.map((expense, index) =>
					<Expense expense={expense} key={index}/>) }
			</div>
			<Modal title={"Ajouter une dépense"} visible={displayAdd} setVisible={setDisplayAdd}>
				<div className={"grid grid-cols-2 items-center gap-2 mt-2"}>
					<p>Nom de la dépense <RedStar/></p>
					<Input
						value={name}
						onInput={e => setName(e.currentTarget.value)}
						placeholder={"Nom"}
					/>
					<p>Description</p>
					<TextArea
						value={description}
						placeHolder={"Description"}
						onInput={e => setDescription(e.currentTarget.value === "" ? undefined : e.currentTarget.value)}
					/>
					<p>Date <RedStar/></p>
					<InputCalendar value={date} setValue={setDate}/>
					<p>Somme <RedStar/></p>
					<Input
						placeholder={"Somme"}
						type={"number"}
						value={amount}
						onInput={e => setAmount(e.currentTarget.value)}
					/>
					<Button
						className={"col-span-2 justify-self-center"} onClick={() => {
							api<TExpense>("/expenses", {
								method: "POST",
								body: {
									name: name,
									description: description === "" ? undefined : description,
									date: date,
									amount: Math.round(parseFloat(amount) * 100),
									event: eventId,
								},
							}).then((res) => {
								if (res.status === 201) {
									setDisplayAdd(false);
									doReload();
									toast("Dépense ajoutée", { type: "success" });
									setName("");
									setDescription("");
									setDate(new Date());
									setAmount("undefined");
								} else {
									toast(res.message, { type: "error" });
								}
							});
						}}
					>
						Ajouter
					</Button>
				</div>
			</Modal>
		</Card>
	);
}

interface ExpenseProps {
	expense: TExpense
}

function Expense(props: ExpenseProps) {
	const [visible, setVisible] = useState(false);
	return (
		<div className={"cursor-pointer"} onClick={() => setVisible(!visible)}>
			<div className={"flex justify-between"}>
				<div className={"flex gap-2 items-center"}>
					<p>{ props.expense.name }</p>
					<p className={"text-sm text-subtext-0"}>{ (props.expense.amount / 100).toFixed(2) } €</p>
					<p>{ dateToFrenchString(props.expense.date) }</p>
				</div>
				<KeyboardArrowDown className={clsx("!transition", visible && "rotate-180" || "rotate-0")}/>
			</div>
			<div className={clsx("transition-all overflow-hidden", visible && "max-h-20" || "max-h-0")}>
				{ props.expense.description }
			</div>
		</div>
	);
}
