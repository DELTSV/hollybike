"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = require("fs");
const node_fs_1 = require("node:fs");
function readJSONFile(file) {
    return JSON.parse((0, fs_1.readFileSync)(file, 'utf8'));
}
function hashReflectEntry(entry) {
    return JSON.stringify(entry);
}
function createHash(json) {
    return json.reduce((acc, entry) => {
        acc[entry.name] = hashReflectEntry(entry);
        return acc;
    }, {});
}
const jsonA = readJSONFile('../backend/processor/src/main/resources/reflect-config-sample.json');
const jsonB = readJSONFile('../backend/native-image/reflect-config.json');
const jsonAHash = createHash(jsonA);
const jsonBHash = createHash(jsonB);
function compareReflectEntries(jsonA, jsonB) {
    return Object.entries(jsonB).reduce((acc, entry) => {
        const [key, value] = entry;
        if (!jsonA[key]) {
            acc.push(JSON.parse(value));
        }
        else if (jsonA[key] !== jsonB[key]) {
            const json = JSON.parse(value);
            console.log(`Different values for ${key}:`);
            console.log(json);
            acc.push(json);
        }
        return acc;
    }, []);
}
const diff = compareReflectEntries(jsonAHash, jsonBHash);
const diffWithout = diff.filter(entry => !entry.name.includes('jdk.internal'));
console.log(`Found ${diff.length} missing or different entries in the sample reflect-config.json`);
(0, node_fs_1.writeFileSync)('./data/diff.json', JSON.stringify(diffWithout, null, 2));
