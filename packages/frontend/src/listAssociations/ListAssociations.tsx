import { useUser } from "../user/useUser.tsx";
import {
	useCallback,
	useEffect, useState,
} from "preact/hooks";
import { useNavigate } from "react-router-dom";
import { useApi } from "../utils/useApi.ts";
import { TAssociation } from "../types/TAssociation.ts";
import { Button } from "../components/Button/Button.tsx";
import { Input } from "../components/Input/Input.tsx";
import {
	ComponentChildren, JSX,
} from "preact";
import { clsx } from "clsx";
import { Search } from "@material-ui/icons";
import { TList } from "../types/TList.ts";

export function ListAssociations() {
	const { user } = useUser();
	const navigate = useNavigate();

	useEffect(() => {
		if (user?.scope !== "Root")
			navigate("/");
	}, [user, navigate]);

	const [page, setPage] = useState(0);

	const [search, setSearch] = useState("");

	const associations = useApi<TList<TAssociation>, never>(`/associations?page=${page}&query=${search}`, [page, search]);

	const onPageChange = useCallback((e: JSX.TargetedEvent<HTMLInputElement>) => {
		const p = parseInt(e.currentTarget.value);
		if (!isNaN(p) && p > 0 && p <= (associations.data?.total_page ?? 1))
			setPage(parseInt(e.currentTarget.value) - 1);
	}, []);

	return (
		<div className={"px-2 flex flex-col grow gap-2"}>
			<Input
				value={search} onInput={e => setSearch(e.currentTarget.value ?? "")}
				placeholder={"Recherche"} className={"self-start"} icon={<Search/>}
			/>
			<table className={"rounded bg-slate-100 dark:bg-slate-800"}>
				<thead>
					<tr className={"rounded"}>
						<th className={"rounded"}>Nom</th>
						<th>Image</th>
						<th>Statut</th>
					</tr>
				</thead>
				<tbody>
					{ associations.data?.data?.map(a =>
						<tr key={a.id} className={"border-t-2 dark:border-slate-700 border-slate-950"}>
							<Cell>{a.name}</Cell>
							<Cell>{a.picture}</Cell>
							<Cell>{a.status}</Cell>
						</tr>
					) }
				</tbody>
			</table>
			<div className={"flex items-center gap-4"}>
				<Button onClick={() => setPage(prev => prev === 0 ? 0 : prev - 1)}>
					Page Précédente
				</Button>
				<p className={"flex gap-1"}>
					<input className={"bg-transparent w-6 text-right"} value={page + 1} onInput={onPageChange}/>
					/
					<span className={"w-6 block"}>{ associations.data?.total_page }</span>
				</p>
				<Button onClick={() => setPage(prev => prev === (associations.data?.total_page ?? 1) - 1 ? prev : prev + 1)}>
					Page Suivante
				</Button>
			</div>
		</div>
	);
}

interface CellProps {
	children: ComponentChildren,
	key?: string | number,
	className?: string
}

function Cell(props: CellProps) {
	return (
		<td className={clsx("text-center px-2 py-1", props.className)} key={props.key}>
			{ props.children }
		</td>
	);
}
