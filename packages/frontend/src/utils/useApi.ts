import {
	Inputs,
	useEffect, useMemo, useState,
} from "preact/hooks";
import { backendBaseUrl } from "../config";
import { externalDisconnect } from "../auth/context.tsx";

interface UseApiOptions {
	method?: string,
	body?: any,
	if?: boolean
}

interface APIResponse<T> {
	status: number,
	message?: string,
	data?: T
}

interface ApiOptions {
	method?: string,
	body?: any,
	headers?: Record<string, string>,
	if?: boolean
}

interface ApiRawOptions {
	method?: string,
	body?: BodyInit,
	headers?: Record<string, string>,
	if?: boolean
}

export function useApi<T>(
	url: string,
	deps?: Inputs,
	options?: UseApiOptions,
) {
	const [result, setResult] = useState<APIResponse<T>>({ status: 0 });

	const stringDeps = JSON.stringify(deps);

	const optionsString = JSON.stringify(options);
	const opt: UseApiOptions | undefined = useMemo(
		() => optionsString !== undefined ? JSON.parse(optionsString) : undefined,
		[optionsString],
	);

	useEffect(() => {
		api<T>(url, options).then((res) => {
			setResult(res);
		});
	}, [
		url,
		opt,
		stringDeps,
	]);

	return result;
}

export async function api<T>(url: string, options?: ApiOptions): Promise<APIResponse<T>> {
	return apiRaw<T>(url, "application/json", {
		method: options?.method,
		body: JSON.stringify(options?.body),
		headers: options?.headers,
		if: options?.if,
	});
}

export async function apiRaw<T>(url: string, type?: string, options?: ApiRawOptions): Promise<APIResponse<T>> {
	const headers = new Headers(options?.headers);
	const token = localStorage.getItem("token") ?? "";
	headers.append("Authorization", `Bearer ${token}`);
	if (type !== undefined) {
		headers.append("Content-Type", type);
	}
	const init: RequestInit = {
		method: options?.method ?? "GET",
		mode: "cors",
		body: options?.body,
		headers: headers,
		credentials: "same-origin",
	};
	let response: Response;
	if (options?.if !== false) {
		try {
			response = await fetch(backendBaseUrl + url, init);
		} catch (e) {
			return {
				status: -1,
				message: "Erreur inconnue",
			};
		}
	} else {
		return { status: 0 };
	}
	const responseText = await response.text();
	if (response.status.toString()[0] !== "2") {
		if (response.status === 401) { externalDisconnect(); }

		if (responseText.length != 0) {
			return {
				status: response.status,
				message: responseText,
			};
		} else {
			return {
				status: response.status,
				message: "Erreur inconnue",
			};
		}
	}
	if (response.status == 204) { return { status: response.status }; }
	try {
		return {
			status: response.status,
			data: JSON.parse(responseText, (_, value) => {
				if (typeof value === "string") {
					if (isISODateTime(value)) { return new Date(value); } else if (isISODate(value)) { return new Date(value); }
				}


				return value;
			}),
		};
	} catch (e) {
		return {
			status: response.status,
			message: responseText,
		};
	}
}

export function isISODateTime(date: string): boolean {
	const regex =
		/^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]{1,6})?(Z|[+-][0-9]{2}:[0-9]{2})$/i;
	return regex.test(date);
}

export function isISODate(date: string): boolean {
	const regex = /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/i;
	return regex.test(date);
}
