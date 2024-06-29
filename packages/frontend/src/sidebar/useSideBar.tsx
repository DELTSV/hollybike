import {
	Dispatch, StateUpdater,
	useContext, useState,
} from "preact/hooks";
import {
	ComponentChildren, createContext,
} from "preact";
import { TAssociation } from "../types/TAssociation.ts";

interface SideBardContext {
	association?: TAssociation;
	setAssociation: (association?: TAssociation) => void;
	visible: boolean,
	setVisible: Dispatch<StateUpdater<boolean>>
}

const SideBar = createContext<SideBardContext>({
	setAssociation: (_?: TAssociation) => {},
	visible: false,
	setVisible: () => {},
});

export function useSideBar() {
	return useContext(SideBar);
}

interface SideBarProviderProps {
	children: ComponentChildren
}

export function SideBarProvider(props: SideBarProviderProps) {
	const [association, setAssociation] = useState<TAssociation>();
	const [visible, setVisible] = useState(false);

	return (
		<SideBar.Provider
			value={{
				association: association,
				setAssociation: setAssociation,
				visible: visible,
				setVisible: setVisible,
			}}
		>
			{ props.children }
		</SideBar.Provider>
	);
}
