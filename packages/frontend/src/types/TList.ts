/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
export interface TList<T> {
	data: T[],
	page: number,
	per_page: number,
	total_data: number,
	total_page: number
}
