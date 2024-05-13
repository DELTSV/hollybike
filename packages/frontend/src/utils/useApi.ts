import {
	Inputs,
	useEffect, useMemo, useState,
} from "preact/hooks";
import { backendBaseUrl } from "../config";

interface UseApiOptions<T> {
	method?: string,
	body?: T
}

interface APIResponse<T> {
	status: number,
	message?: string,
	data?: T
}

interface ApiOptions<T> {
	method?: string,
	body?: T,
	headers?: Record<string, string>
}

interface ApiRawOptions {
	method?: string,
	body?: BodyInit,
	headers?: Record<string, string>
}

export function useApi<T, B>(
	url: string,
	deps?: Inputs,
	options?: UseApiOptions<B>,
) {
	const [result, setResult] = useState<APIResponse<T>>({ status: 0 });

	const stringDeps = JSON.stringify(deps);

	const optionsString = JSON.stringify(options);
	const opt: UseApiOptions<B> | undefined = useMemo(
		() => optionsString !== undefined ? JSON.parse(optionsString) : undefined,
		[optionsString],
	);

	useEffect(() => {
		api<T, B>(url, options).then((res) => {
			setResult(res);
		});
	}, [
		url,
		opt,
		stringDeps,
	]);

	return result;
}

export async function api<T, B>(url: string, options?: ApiOptions<B>): Promise<APIResponse<T>> {
	return apiRaw<T>(url, "application/json", {
		method: options?.method,
		body: JSON.stringify(options?.body),
		headers: options?.headers,
	});
}

export async function apiRaw<T>(url: string, type: string, options?: ApiRawOptions): Promise<APIResponse<T>> {
	const headers = new Headers(options?.headers);
	const token = localStorage.getItem("token") ?? "";
	headers.append("Authorization", `Bearer ${token}`);
	headers.append("Content-Type", type);
	const init: RequestInit = {
		method: options?.method ?? "GET",
		mode: "cors",
		body: options?.body,
		headers: headers,
		credentials: "same-origin",
	};
	let response: Response;
	try {
		response = await fetch(backendBaseUrl + url, init);
	} catch (e) {
		return {
			status: -1,
			message: "Erreur inconnue",
		};
	}
	if (response.status.toString()[0] !== "2") {
		const responseText = await response.text();
		if (responseText.length != 0)
			return {
				status: response.status,
				message: responseText,
			};
		 else
			return {
			 	status: response.status,
				message: "Erreur inconnue",
			};
	}
	if (response.status == 204)
		return { status: response.status };
	try {
		return {
			status: response.status,
			data: await response.json(),
		};
	} catch (e) {
		return {
			status: response.status,
			message: await response.text(),
		};
	}
}
