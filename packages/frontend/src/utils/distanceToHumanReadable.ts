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
