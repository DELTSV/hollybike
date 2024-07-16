/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
export interface TLogin {
	email: string;
	password: string;
}

export interface TAuthInfo {
	token: string,
	refresh_token: string,
	deviceId: string
}
