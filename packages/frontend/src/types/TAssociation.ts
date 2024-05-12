export interface TAssociation {
	id: number,
	name: string,
	status: string,
	picture?: string
}

export const dummyAssociation: TAssociation = {
	id: -1,
	name: "dummyAssociation",
	status: "None",
};
