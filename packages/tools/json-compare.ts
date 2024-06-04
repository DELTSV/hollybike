import {readFileSync} from 'fs';
import {writeFileSync} from "node:fs";

interface ReflectEntry {
	name: string;
}

function readJSONFile(file: string): ReflectEntry[] {
	return JSON.parse(readFileSync(file, 'utf8'));
}

function hashReflectEntry(entry: ReflectEntry): string {
	return JSON.stringify(entry);
}

function createHash(json: ReflectEntry[]): Record<string, string> {
	return json.reduce((acc, entry) => {
		acc[entry.name] = hashReflectEntry(entry);
		return acc;
	}, {} as Record<string, string>);
}

const jsonA = readJSONFile('../backend/processor/src/main/resources/reflect-config-sample.json');
const jsonB = readJSONFile('../backend/native-image/reflect-config.json');

const jsonAHash = createHash(jsonA);
const jsonBHash = createHash(jsonB);

function compareReflectEntries(jsonA: Record<string, string>, jsonB: Record<string, string>): ReflectEntry[] {
	return Object.entries(jsonB).reduce((acc, entry) => {
		const [key, value] = entry;
		if (!jsonA[key]) {
			acc.push(JSON.parse(value));
		} else if (jsonA[key] !== jsonB[key]) {
			const json = JSON.parse(value);
			console.log(`Different values for ${key}:`);
			console.log(json);
			acc.push(json);
		}
		return acc;
	}, [] as ReflectEntry[]);
}

const diff = compareReflectEntries(jsonAHash, jsonBHash);

const diffWithout = diff.filter(entry => !entry.name.includes('jdk.internal'));

writeFileSync('./data/diff.json', JSON.stringify(diffWithout, null, 2));