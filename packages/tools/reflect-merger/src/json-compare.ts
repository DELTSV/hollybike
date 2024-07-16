/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {readFileSync} from 'fs';
import {writeFileSync} from "node:fs";
import {NamedEntry, ReflectDiffResult, ReflectDiffValueResult, ReflectEntry, ReflectMethod} from "./types";

const defaultReflectDiffResult = <T>(): ReflectDiffResult<T> => ({
	merged: [],
	added: 0,
	updated: 0,
	totalOperations: 0,
});

export const readJSONFile = (file: string): ReflectEntry[] => JSON.parse(readFileSync(file, 'utf8'));

export const createReflectEntryMap = (
	json?: ReflectEntry[]
): Record<string, ReflectEntry> =>(json || []).reduce((acc, entry) => {
	acc[entry.name] = entry;
	return acc;
}, {} as Record<string, ReflectEntry>);

export const createMapForMethods = (json?: ReflectMethod[]): Record<string, ReflectMethod> => (json || []).reduce((acc, entry) => {
	acc[`${entry.name};${entry.parameterTypes.join(':')}`] = entry;
	return acc;
}, {} as Record<string, ReflectMethod>);

const getMissingFields = (
	jsonA: ReflectEntry,
	jsonB: ReflectEntry
): NamedEntry[] => (jsonB.fields || []).filter(field => !(jsonA.fields || []).find(f => f.name === field.name));

const getMergedReflectMethod = (jsonA:  Record<string, ReflectMethod>, jsonB:  Record<string, ReflectMethod>): ReflectDiffResult<ReflectMethod> => {
	return [...new Set([...Object.keys(jsonA), ...Object.keys(jsonB)])].reduce((acc, key) => {
		const methodA = jsonA[key];
		const methodB = jsonB[key];

		if (!methodA) {
			console.log(`Missing method ${key}`);
			return {
				...acc,
				merged: [...acc.merged, methodB],
				added: acc.added + 1,
				totalOperations: acc.totalOperations + 1,
			};
		}

		if (!methodB) {
			return {
				...acc,
				merged: [...acc.merged, methodA],
			};
		}

		return {
			...acc,
			merged: [...acc.merged, methodA],
		};
	}, defaultReflectDiffResult<ReflectMethod>());
}

const mergeBooleanValue = (jsonA: ReflectEntry, jsonB: ReflectEntry, field: keyof ReflectEntry): ReflectDiffValueResult<boolean | undefined> => {
	const isUpdated = jsonB[field] != null &&
		jsonA[field] != null &&
		jsonB[field] !== jsonA[field];

	if (isUpdated) {
		console.log(`Different ${field} for ${jsonA.name}: ${jsonA[field]} vs ${jsonB[field]}`);
	}

	return {
		merged: isUpdated ? jsonB[field] as boolean : jsonA[field] as boolean,
		totalOperations: isUpdated ? 1 : 0,
	};
};

const getMergedReflectEntry = (jsonA: ReflectEntry, jsonB: ReflectEntry): ReflectDiffValueResult<ReflectEntry> => {
	let operationsCount = 0;

	const missingFields = getMissingFields(jsonA, jsonB);

	if (missingFields.length) {
		operationsCount += missingFields.length;
		console.log(`Missing fields for ${jsonA.name}: ${missingFields.map(f => f.name).join(', ')}`);
	}

	const fields = [...(jsonA.fields || []), ...missingFields];

	const booleanFields: Array<keyof ReflectEntry> = [
		'queryAllPublicMethods',
		'allPublicFields',
		'queryAllDeclaredMethods'
	];

	const [
		queryAllPublicMethods,
		allPublicFields,
		queryAllDeclaredMethods
	] = booleanFields.map(field => {
		const result = mergeBooleanValue(jsonA, jsonB, field);
		operationsCount += result.totalOperations;
		return result.merged;
	});

	const methodsDiffResult = getMergedReflectMethod(
		createMapForMethods(jsonA.methods),
		createMapForMethods(jsonB.methods)
	);

	operationsCount += methodsDiffResult.totalOperations;

	return {
		merged: {
			name: jsonA.name,
			queryAllPublicMethods,
			allPublicFields,
			queryAllDeclaredMethods,
			fields: fields.length ? fields : undefined,
			methods: methodsDiffResult.merged.length ? methodsDiffResult.merged : undefined,
		},
		totalOperations: operationsCount,
	};
}

export const mergeReflectEntries = (
	jsonA: Record<string, ReflectEntry>,
	jsonB: Record<string, ReflectEntry>
): ReflectDiffResult<ReflectEntry> => {
	return [...new Set([...Object.keys(jsonA), ...Object.keys(jsonB)])].reduce((acc, key) => {
		const entryA = jsonA[key];
		const entryB = jsonB[key];

		if (!entryA) {
			console.log(`Missing entry ${key}`);
			return {
				...acc,
				merged: [...acc.merged, entryB],
				added: acc.added + 1,
				totalOperations: acc.totalOperations + 1,
			};
		}

		if (!entryB) {
			return {
				...acc,
				merged: [...acc.merged, entryA],
			};
		}

		const mergedEntry = getMergedReflectEntry(entryA, entryB);

		return {
			...acc,
			merged: [...acc.merged, mergedEntry.merged],
			updated: acc.updated + (mergedEntry.totalOperations > 0 ? 1 : 0),
			totalOperations: acc.totalOperations + mergedEntry.totalOperations,
		};
	}, defaultReflectDiffResult<ReflectEntry>());
}

export const writeDiffOutput = (diff: ReflectDiffResult<ReflectEntry>): void => {
	console.log(`Added: ${diff.added}, Updated: ${diff.updated}, Total Operations: ${diff.totalOperations}`);

	if (!require('fs').existsSync('./out')) {
		require('fs').mkdirSync('./out');
	}

	writeFileSync('./out/merged.json', JSON.stringify(diff.merged, null, "\t"));
}
