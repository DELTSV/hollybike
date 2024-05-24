export function equals(a: any, b: any): boolean {
	if (a === b)
		return true;

	if (a === null || b === null || a === undefined || b === undefined || typeof a !== "object" || typeof b !== "object")
		return false;

	const aKeys = Object.keys(a);
	const bKeys = Object.keys(b);

	if (aKeys.length !== bKeys.length)
		return false;

	for (const key in aKeys)
		if (!bKeys.includes(key) || !equals(a[key], b[key]))
			return false;

	return true;
}
