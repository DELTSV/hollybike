/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
export interface TInvitationCreation {
	label: string,
	role: string,
	association?: number,
	maxUses?: number,
	expiration?: string
}
