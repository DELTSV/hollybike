import { Filter } from "../../icons/Filter.tsx";
import { Button } from "../Button/Button.tsx";
import { useState } from "preact/hooks";
import { clsx } from "clsx";
import { TMetaData } from "./List.tsx";

interface FiltersProps {
	metaData: TMetaData
}

export function Filters(props: FiltersProps) {
	const [visible, setVisible] = useState(false);
	return (
		<div className={"relative"}>
			<Button onClick={() => { setVisible(prev => !prev); }}>
				<Filter/>Filtre
			</Button>
			{ visible &&
				<div
					className={clsx(
						"absolute right-0 bg-slate-300 dark:bg-slate-800 p-2",
						"border-2 border-slate-950 dark:border-slate-700 rounded",
					)}
				>
					{ Object.entries(props.metaData).map(([k, v]) => <p>{ k }</p>) }
				</div> }
		</div>
	);
}
