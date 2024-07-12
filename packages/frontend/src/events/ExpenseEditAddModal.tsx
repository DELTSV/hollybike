import { TExpense } from "../types/TExpense.ts";
import {
	Dispatch, StateUpdater, useCallback, useEffect, useState,
} from "preact/hooks";
import { RedStar } from "../components/RedStar/RedStar.tsx";
import { Input } from "../components/Input/Input.tsx";
import { TextArea } from "../components/Input/TextArea.tsx";
import { InputCalendar } from "../components/Calendar/InputCalendar.tsx";
import { FileInput } from "../components/Input/FileInput.tsx";
import { Button } from "../components/Button/Button.tsx";

import { toast } from "react-toastify";
import { Modal } from "../components/Modal/Modal.tsx";
import { DoReload } from "../utils/useReload.ts";
import {
	api, apiRaw,
} from "../utils/useApi.ts";

interface ExpenseEditAddModalProps {
	type: "edit" | "add",
	data?: TExpense,
	setData: Dispatch<StateUpdater<TExpense | undefined>>,
	visible: boolean,
	setVisible: Dispatch<StateUpdater<boolean>>,
	eventId: number,
	doReload: DoReload
}

export function ExpenseEditAddModal(props: ExpenseEditAddModalProps) {
	const {
		eventId,
		visible,
		setVisible,
		data,
		type,
		doReload,
		setData,
	} = props;
	const [name, setName] = useState("");
	const [description, setDescription] = useState<string>();
	const [date, setDate] = useState<Date | undefined>(new Date());
	const [amount, setAmount] = useState("");
	const [proof, setProof] = useState<File | null>(null);
	const reset = useCallback(() => {
		setVisible(false);
		doReload();
		toast("Dépense ajoutée", { type: "success" });
		setName("");
		setDescription("");
		setDate(new Date());
		setAmount("");
		setProof(null);
		setData(undefined);
	}, [
		setVisible,
		doReload,
		toast,
		setName,
		setDescription,
		setDate,
		setAmount,
		setProof,
		setData,
	]);
	const add = useCallback(() => {
		api<TExpense>("/expenses", {
			method: "POST",
			body: {
				name: name,
				description: description === "" ? undefined : description,
				date: date,
				amount: Math.round(parseFloat(amount) * 100),
				event: eventId,
			},
		}).then(async (res) => {
			if (res.status === 201) {
				if (proof !== null) {
					const fd = new FormData();
					fd.append("file", proof);
					apiRaw(`/expenses/${res.data?.id}/proof`, undefined, {
						method: "PUT",
						body: fd,
					}).then((res) => {
						if (res.status === 200) {
							reset();
						} else {
							toast(res.message, { type: "error" });
						}
					});
				} else {
					reset();
				}
			} else {
				toast(res.message, { type: "error" });
			}
		});
	}, [
		name,
		description,
		date,
		amount,
		eventId,
		reset,
		proof,
	]);
	const edit = useCallback(() => {
		if (data) {
			api<TExpense>(`/expenses/${data?.id}`, {
				method: "PATCH",
				body: {
					name: name,
					description: description === "" ? undefined : description,
					date: date,
					amount: Math.round(parseFloat(amount) * 100),
					event: eventId,
				},
			}).then(async (res) => {
				if (res.status === 200) {
					if (proof !== null) {
						const fd = new FormData();
						fd.append("file", proof);
						apiRaw(`/expenses/${res.data?.id}/proof`, undefined, {
							method: "PUT",
							body: fd,
						}).then((res) => {
							if (res.status === 200) {
								reset();
							} else {
								toast(res.message, { type: "error" });
							}
						});
					} else {
						reset();
					}
				} else {
					toast(res.message, { type: "error" });
				}
			});
		}
	}, [
		name,
		description,
		date,
		amount,
		eventId,
		reset,
		proof,
	]);
	useEffect(() => {
		if (data) {
			setName(data.name);
			setDescription(data.description);
			setDate(new Date());
			setAmount((data.amount / 100).toFixed(2));
			setProof(null);
		}
	}, [data]);
	return (
		<Modal visible={visible} setVisible={setVisible}>
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
				<p>Preuve d'achat</p>
				<FileInput value={proof} setValue={setProof} placeholder={"Preuve d'achat"}/>
				<Button
					className={"col-span-2 justify-self-center"} onClick={async () => {
						if (type === "add") {
							add();
						} else if (type === "edit") {
							edit();
						}
					}}
				>
				Ajouter
				</Button>
			</div>
		</Modal>
	);
}
