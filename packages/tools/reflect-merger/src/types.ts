export interface NamedEntry {
	name: string;
}

export interface ReflectMethod extends NamedEntry {
	parameterTypes: string[];
}

export interface ReflectEntry extends NamedEntry {
	queryAllPublicMethods?: boolean;
	queryAllDeclaredMethods?: boolean;
	allPublicFields?: boolean;
	fields?: NamedEntry[];
	methods?: ReflectMethod[];
}

export interface ReflectDiffResult<T> {
	merged: T[];
	added: number;
	updated: number;
	totalOperations: number;
}

export interface ReflectDiffValueResult<T> {
	merged: T;
	totalOperations: number;
}