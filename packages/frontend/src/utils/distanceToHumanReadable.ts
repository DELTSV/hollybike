/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
export function distanceToHumanReadable(distance?: number) {
	if (!distance) {
		return "";
	} else if (distance < 1000) {
		return Intl.NumberFormat("fr-FR", {
			style: "unit",
			unit: "meter",
			unitDisplay: "narrow",
			maximumFractionDigits: 2,
		}).format(distance);
	} else {
		return Intl.NumberFormat("fr-FR", {
			style: "unit",
			unit: "kilometer",
			unitDisplay: "narrow",
			maximumFractionDigits: 3,
		}).format(distance/1000);
	}
}
