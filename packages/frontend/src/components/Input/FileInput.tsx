import {
	Dispatch, StateUpdater,
	useMemo, useState,
} from "preact/hooks";
import { v4 } from "uuid";
import { clsx } from "clsx";

interface FileInputProps {
	placeholder?: string,
	accept?: string,
	id?: string,
	value: File | null
	setValue: Dispatch<StateUpdater<File | null>>
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

	return (
		<label
			className={clsx(
				"border-2 rounded cursor-pointer bg-slate-100 dark:bg-slate-800",
				"border-slate-950 dark:border-slate-700 p-2 h-9.5 flex items-center justify-start",
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
