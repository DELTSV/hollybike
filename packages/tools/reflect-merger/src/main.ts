import {createReflectEntryMap, mergeReflectEntries, readJSONFile, writeDiffOutput} from "./json-compare";
import {writeFileSync} from "node:fs";
import {readFileSync} from "fs";

function main() {
	const args = process.argv.slice(2);

	if (args.length < 2) {
		console.error('Usage: node main.js <jsonA> <jsonB>');
		process.exit(1);
	}

	const replaceOriginal = args.includes('--replace-original');

	const [jsonAPath, jsonBPath] = args;

	[jsonAPath, jsonBPath].forEach(path => {
		if (!require('fs').existsSync(path)) {
			console.error(`File ${path} does not exist`);
			process.exit(1);
		}
	});

	const [jsonA, jsonB] = [jsonAPath, jsonBPath].map(path => {
		try {
			return readJSONFile(path);
		} catch (e) {
			if (e instanceof Error) {
				console.error(`Error reading JSON file ${path}: ${e.message}`);
			}

			process.exit(1);
		}
	});

	const output = mergeReflectEntries(
		createReflectEntryMap(jsonA),
		createReflectEntryMap(jsonB.filter(entry => !entry.name.includes('jdk.internal')))
	);

	writeDiffOutput(output);

	if (replaceOriginal) {
		writeFileSync('./out/original.json', readFileSync(jsonAPath, 'utf8'));
		writeFileSync(jsonAPath, readFileSync('./out/merged.json', 'utf8'));
	}
}

main();