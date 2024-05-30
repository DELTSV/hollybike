export interface TInvitation {
	id: number,
	role: string,
	status: string,
	expiration: string,
	creation: string,
	uses: number,
	max_uses: number | null,
	link?: string
}
