export interface TExpense {
	id: number,
	name: string,
	description?: string,
	date: Date,
	amount: number,
	proof?: string
}
