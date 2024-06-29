export interface TLogin {
	email: string;
	password: string;
}

export interface TAuthInfo {
	token: string,
	refresh_token: string,
	deviceId: string
}
