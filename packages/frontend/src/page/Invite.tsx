/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
export function Invite() {
	return (
		<div className={"flex items-center gap-8 justify-center flex-col p-12"}>
			<img src={"/cropped-logo.png"} alt={"logo"}/>
			<a
				className={"w-full sm:w-3/4 lg:w-1/2 flex justify-center"}
				href="https://play.google.com/store/apps/details?id=com.hollybike.hollybike&pcampaignid=pcampaignidMKT-
				Other-global-all-co-prtnr-py-PartBadge-Mar2515-1"
			>
				<img
					alt="Disponible sur Google Play"
					src="https://play.google.com/intl/en_us/badges/static/images/badges/fr_badge_web_generic.png"
				/>
			</a>
		</div>
	);
}
