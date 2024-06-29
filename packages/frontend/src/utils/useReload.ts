import { useState } from "preact/hooks";

export type Reload = boolean
export type DoReload = () => void

interface UseReload {
	reload: Reload,
	doReload: DoReload,
}

export function useReload(): UseReload {
	const [reload, setReload] = useState(false);
	return {
		reload: reload,
		doReload: () => setReload(prev => !prev),
	};
}
