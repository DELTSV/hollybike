/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
export interface TConf {
	db?: {
		url?: string,
		username?: string,
		password?: string
	},
	security?: {
		audience?: string,
		domain?: string,
		realm?: string,
		secret?: string
	},
	smtp?: {
		url?: string,
		port?: number,
		sender?: string,
		username?: string,
		password?: string
	},
	storage?: {
		s3Url?: string,
		s3Bucket?: string,
		s3Region?: string,
		s3Username?: string,
		s3Password?: string,
		localPath?: string,
		ftpServer?: string,
		ftpUsername?: string,
		ftpPassword?: string,
		ftpDirectory?: string
	}
}
