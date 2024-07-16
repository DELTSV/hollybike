/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
export interface TUserUpdate {
	username?: string,
	email?: string,
	password?: string,
	status?: string,
	scope?: string,
	association?: number,
	role?: string,
}
