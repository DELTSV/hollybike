/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
export interface TExpense {
	id: number,
	name: string,
	description?: string,
	date: Date,
	amount: number,
	proof?: string
}
