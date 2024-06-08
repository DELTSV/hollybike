const isAnObject = (v: unknown): v is Record<string | number, unknown> => v === null || typeof v !== "object";

export function equals<T>(a: T, b: unknown): b is T {
	if (a === b) {
		return true;
	}

	if (!isAnObject(a) || !isAnObject(b)) {
		return false;
	}

	const aKeys = Object.keys(a);
	const bKeys = Object.keys(b);

	if (aKeys.length !== bKeys.length) {
		return false;
	}

	return !aKeys.some(key => !bKeys.includes(key) || !equals(a[key], b[key]));
}

