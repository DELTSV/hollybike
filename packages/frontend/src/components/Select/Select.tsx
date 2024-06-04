import {
	useCallback,
	useEffect, useMemo, useState,
} from "preact/hooks";
import { ArrowDropDown } from "@material-ui/icons";
import { clsx } from "clsx";
import { useRef } from "react";
import {
	decInputCount, inputCount,
} from "../InputCount.ts";

export interface Option {
	value: string | number,
	name: string
}

interface SelectProps {
	options: Option[],
	placeholder?: string,
	default?: string | number,
	value?: string | number,
	onChange?: (value: string | number | undefined) => void,
	disabled?: boolean,
	searchable?: boolean,
	searchPlaceHolder?: string
}

export function Select(props: SelectProps) {
	const id = useMemo(() => {
		const tmp = inputCount;
		decInputCount();
		return tmp;
	}, []);
	const [text, setText] = useState(props.placeholder);

	const [visible, setVisible] = useState(false);

	const [search, setSearch] = useState("");

	const container = useRef<HTMLDivElement>(null);

	const input = useRef<HTMLInputElement>(null);

	const handleOut = useCallback((e: MouseEvent) => {
		if (
			container.current &&
			!container.current.contains(e.target as Node) &&
			input.current &&
			!input.current.contains(e.target as Node)
		)
			setVisible(false);
	}, [
		container,
		input,
		setVisible,
	]);

	useEffect(() => {
		document.addEventListener("mousedown", handleOut);
		return () => {
			document.removeEventListener("mousedown", handleOut);
		};
	}, [handleOut]);

	useEffect(() => {
		if (props.default !== undefined) {
			const opt = props.options.find(o => o.value == props.default);
			setText(opt?.name ?? props.placeholder);
		}
	}, [
		props.default,
		props.options,
		props.default,
		props.value,
	]);

	const filteredOptions = useMemo(() => {
		if (props.searchable)
			return props.options.filter(o => o.name.toLowerCase().includes(search.toLowerCase()));
		 else
			return props.options;
	}, [
		props.options,
		search,
		props.searchable,
	]);

	return (
		<div
			className={clsx(
				"bg-slate-100 dark:bg-slate-800 rounded flex items-center justify-between border-2 px-2 py-2 h-9.5 relative",
				visible && "rounded-b-none",
				props.disabled === true ?
					"border-slate-300 text-slate-300 dark:border-slate-600 dark:text-slate-600 cursor-default" :
					"border-slate-950 dark:border-slate-700 cursor-pointer",
			)}
			onClick={(e) => {
				if (input.current?.contains(e.target as Node) !== true)
					setVisible(prev => !prev);
			}} ref={container}
			style={`z-index: ${id}`}
		>
			<p>{ text }</p>
			<ArrowDropDown className={clsx("transition", visible && "rotate-180")}/>
			{ visible &&
				<div
					className={"absolute top-full -left-0.5 bg-slate-100 dark:bg-slate-800 flex flex-col " +
					"w-[calc(100%+4px)] border-2 border-slate-950 dark:border-slate-700 rounded-b"}
				>
					{ props.searchable &&
						<input
							className={"bg-transparent m-1 p-1 border-2 border-slate-700 rounded focus:outline-none"}
							ref={input} value={search}
							onInput={e => setSearch(e.currentTarget.value)}
						/> }
					{ filteredOptions.map(o =>
						<p
							className={"p-2 cursor-pointer hover:bg-slate-200 dark:hover:bg-slate-900"}
							onClick={(e) => {
								props.onChange && props.onChange(o.value);
								setVisible(false);
								setText(o.name);
								e.preventDefault();
								e.stopPropagation();
							}}
						>
							{ o.name }
						</p>) }
				</div> }
			<select disabled={props.disabled} className={"hidden"} value={props.value}>
				<option default={props.default === undefined}></option>
				{ props.options.map((o, i) =>
					<option default={props.default === o.value} key={i} value={o.value}>{ o.name }</option>) }
			</select>
		</div>
	);
}
