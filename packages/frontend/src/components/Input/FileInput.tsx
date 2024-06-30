import {
	Dispatch, StateUpdater, useEffect,
	useMemo, useState,
} from "preact/hooks";
import { v4 } from "uuid";
import { clsx } from "clsx";

interface FileInputProps {
	placeholder?: string,
	accept?: string,
	id?: string,
	value: File | null
	setValue: Dispatch<StateUpdater<File | null>>,
	className?: string
}

export function FileInput(props: FileInputProps) {
	const id = useMemo(() => {
		if (props.id) {
			return props.id;
		} else {
			return v4();
		}
	}, [props.id]);

	const [v, setV] = useState("");

	const [text, setText] = useState(props.placeholder ?? "");

	const textCss = useMemo(() => {
		if (text === props.placeholder) {
			return "text-gray-400";
		} else {
			return "";
		}
	}, [props.placeholder, text]);

	useEffect(() => {
		if (props.value === null && props.placeholder) {
			setText(props.placeholder);
		}
	}, [props.placeholder, setText]);

	return (
		<label
			className={clsx(
				"border-2 rounded cursor-pointer bg-surface-1",
				"border-lavender p-2 h-9.5 flex items-center justify-start",
				textCss,
			)}
			for={id}
		>
			{ text }
			<input
				value={v}
				className={"hidden text-gray-600"}
				id={id} type={"file"}
				placeholder={props.placeholder}
				accept={props.accept}
				onInput={(e) => {
					setV(e.currentTarget.value);
					if (e.currentTarget.files !== null && e.currentTarget.files.length !== 0) {
						setText(e.currentTarget.files[0].name);
						props.setValue(e.currentTarget.files[0]);
					}
				}}
			/>
		</label>
	);
}
