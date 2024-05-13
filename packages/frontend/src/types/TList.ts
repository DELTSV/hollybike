export interface TList<T> {
	data: T[],
	page: number,
	per_page: number,
	total_data: number,
	total_page: number
}
