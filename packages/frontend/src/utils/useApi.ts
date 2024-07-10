import {
	Inputs, useEffect, useMemo, useState,
} from "preact/hooks";
import { backendBaseUrl } from "../config";
import { TAuthInfo } from "../auth/types";
import { externalDisconnect } from "../auth/context.tsx";

interface UseApiOptions {
	method?: string,
	body?: any,
	if?: boolean,
	retryIfUnauthorized?: boolean,
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
	if?: boolean,
	retryIfUnauthorized?: boolean,
}

interface ApiRawOptions {
	method?: string,
	body?: BodyInit,
	headers?: Record<string, string>,
	if?: boolean,
	retryIfUnauthorized?: boolean,
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
		retryIfUnauthorized: options?.retryIfUnauthorized,
	});
}

export async function apiRaw<T>(url: string, type?: string, options?: ApiRawOptions): Promise<APIResponse<T>> {
	let response: Response;
	if (options?.if !== false) {
		try {
			response = await apiResponseRaw(url, type, options);
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
		if (response.status === 401 && options?.retryIfUnauthorized !== false) {
			if (localStorage.getItem("refreshing") !== "true") {
				localStorage.setItem("refreshing", "true");
				const refreshToken = localStorage.getItem("refreshToken");
				const deviceId = localStorage.getItem("deviceId");
				if (refreshToken === null || deviceId === null) {
					return {
						status: response.status,
						message: responseText,
					};
				}
				api<TAuthInfo>("/auth/refresh", {
					method: "PATCH",
					body: {
						device: deviceId,
						token: refreshToken,
					},
				}).then((res) => {
					if (res.status === 200 && res.data) {
						localStorage.setItem("refreshToken", res.data.refresh_token);
						localStorage.setItem("deviceId", res.data.deviceId);
						localStorage.setItem("token", res.data.token);
						localStorage.removeItem("refreshing");
						return apiRaw<T>(url, type, options);
					} else if (res.status === 403) {
						externalDisconnect();
					} else {
						return {
							status: response.status,
							message: responseText,
						};
					}
				});
			} else {
				setTimeout(() => {
					apiRaw(url, type, options);
				}, 1_000);
			}
		}

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
	if (response.status === 204) {
		return { status: response.status };
	}

	try {
		return {
			status: response.status,
			data: JSON.parse(responseText, (_, value) => {
				if (typeof value === "string") {
					if (isISODateTime(value)) {
						return new Date(value);
					} else if (isISODate(value)) {
						return new Date(value);
					}
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

export async function apiResponseRaw(url: string, type?: string, options?: ApiRawOptions): Promise<Response> {
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
	return await fetch(backendBaseUrl + url, init);
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
