import {
	Head, Sort,
} from "./Head.tsx";
import { useApi } from "../../utils/useApi.ts";
import {
	useCallback,
	useEffect, useMemo, useState,
} from "preact/hooks";
import { Search } from "@material-ui/icons";
import { Input } from "../Input/Input.tsx";
import {
	ComponentChildren, JSX,
} from "preact";
import { TList } from "../../types/TList.ts";
import { Button } from "../Button/Button.tsx";
import { Reload } from "../../utils/useReload.ts";

interface ListProps<T> {
	columns: Columns[],
	baseUrl: string,
	line: (data: T) => ComponentChildren[]
	perPage?: number,
	reload?: Reload,
	filter?: string
}

export function List<T>(props: ListProps<T>) {
	const sortFilterColumns = useApi<TMetaData>(`${props.baseUrl}/meta-data`);
	const [sort, setSort] = useState<{[name: string]: Sort}>({});
	const [search, setSearch] = useState("");
	const [page, setPage] = useState(0);

	useEffect(() => {
		const sortMap: {[name: string]: Sort} = {};
		Object.keys(sortFilterColumns.data ?? []).forEach((c) => {
			sortMap[c] = {
				column: c,
				order: "none",
			};
		});
		setSort(sortMap);
	}, [sortFilterColumns, setSort]);

	const setOrder = useCallback((col: string) => {
		if (sort[col] !== undefined)
			return (order: "asc" | "desc" | "none") => {
				const tmp = { ...sort[col] };
				tmp.order = order;
				const res = { ...sort };
				res[col] = tmp;
				setSort(res);
			};

		return undefined;
	}, [sort, setSort]);

	const onPageChange = useCallback((e: JSX.TargetedEvent<HTMLInputElement>) => {
		const p = parseInt(e.currentTarget.value);
		if (!isNaN(p) && p > 0 && p <= (data.data?.total_page ?? 1))
			setPage(parseInt(e.currentTarget.value) - 1);
	}, []);

	const orderQuery = useMemo(() => {
		const sortStrings = Object.values(sort)
			.filter(s => s.order !== "none")
			.map(s => `sort=${s.column}.${s.order}`);
		if (sortStrings.length > 0)
			return `&${ sortStrings.join("&")}`;
		 else
			return "";
	}, [sort]);

	const filterQuery = useMemo(() => {
		if (props.filter !== undefined && props.filter.length !== 0)
			return `&${ props.filter}`;
		 else
			return "";
	}, []);

	const data = useApi<TList<T>>(
		`${props.baseUrl}?page=${page}&per_page=${props.perPage ?? 10}&query=${search}${orderQuery}${filterQuery}`,
		[
			props.baseUrl,
			props.perPage,
			page,
			search,
			orderQuery,
			props.reload,
		],
	);

	return (
		<div className={"px-2 flex flex-col grow gap-2"}>
			<Input
				value={search} onInput={e => setSearch(e.currentTarget.value ?? "")}
				placeholder={"Recherche"} className={"self-start"} leftIcon={<Search/>}
			/>
			<table className={"rounded bg-slate-100 dark:bg-slate-800 table-fixed"}>
				<thead>
					<tr>
						{ props.columns.map((c) => {
							const sortColumn = sort[c.id];
							if (c.visible !== false)
								return (
									<Head
										sortable={sortColumn !== undefined}
										sort={sortColumn}
										setSortOrder={setOrder(c.id)}
										width={c.width}
									>
										{ c.name }
									</Head>
								);
							else
								return null;
						}) }
					</tr>
				</thead>
				<tbody>
					{ data.data?.data?.map(d =>
						<tr className={"border-t-2 border-slate-600"}>
							{ props.line(d).filter((_, i) => props.columns[i]?.visible !== false) }
						</tr>) }
				</tbody>
			</table>
			<div className={"flex items-center gap-4"}>
				<Button onClick={() => setPage(prev => prev === 0 ? 0 : prev - 1)}>
						Page Précédente
				</Button>
				<p className={"flex gap-1"}>
					<input className={"bg-transparent w-6 text-right"} value={page + 1} onInput={onPageChange}/>
					/
					<span className={"w-6 block"}>{ data.data?.total_page }</span>
				</p>
				<Button
					onClick={() => setPage(prev => prev === (data.data?.total_page ?? 1) - 1 ? prev : prev + 1)}
				>
						Page Suivante
				</Button>
			</div>
		</div>
	);
}

interface Columns {
	name: string,
	id: string,
	width?: string,
	visible?: boolean
}

interface TMetaData {
	[name: string]: string
}
