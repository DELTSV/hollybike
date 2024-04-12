export type ConnectionDTO = {
	username: string;
	password: string;
};

export type LoginDTO = { email: string } & ConnectionDTO;
