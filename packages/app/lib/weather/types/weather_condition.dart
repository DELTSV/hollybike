/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
enum WeatherCondition {
  clearSky,
  mainlyClear,
  partlyCloudy,
  overcast,
  fog,
  depositingRimeFog,
  drizzleLight,
  drizzleModerate,
  drizzleDense,
  freezingDrizzleLight,
  freezingDrizzleDense,
  rainSlight,
  rainModerate,
  rainHeavy,
  freezingRainLight,
  freezingRainHeavy,
  snowFallSlight,
  snowFallModerate,
  snowFallHeavy,
  snowGrains,
  rainShowersSlight,
  rainShowersModerate,
  rainShowersViolent,
  snowShowersSlight,
  snowShowersHeavy,
  thunderstormSlightOrModerate,
  thunderstormWithHailSlight,
  thunderstormWithHailHeavy,
}

WeatherCondition? getWeatherCondition(int code) {
  switch (code) {
    case 0:
      return WeatherCondition.clearSky;
    case 1:
      return WeatherCondition.mainlyClear;
    case 2:
      return WeatherCondition.partlyCloudy;
    case 3:
      return WeatherCondition.overcast;
    case 45:
      return WeatherCondition.fog;
    case 48:
      return WeatherCondition.depositingRimeFog;
    case 51:
      return WeatherCondition.drizzleModerate;
    case 53:
      return WeatherCondition.drizzleLight;
    case 55:
      return WeatherCondition.drizzleDense;
    case 56:
      return WeatherCondition.freezingDrizzleLight;
    case 57:
      return WeatherCondition.freezingDrizzleDense;
    case 61:
      return WeatherCondition.rainSlight;
    case 63:
      return WeatherCondition.rainModerate;
    case 65:
      return WeatherCondition.rainHeavy;
    case 66:
      return WeatherCondition.freezingRainLight;
    case 67:
      return WeatherCondition.freezingRainHeavy;
    case 71:
      return WeatherCondition.snowFallSlight;
    case 73:
      return WeatherCondition.snowFallModerate;
    case 75:
      return WeatherCondition.snowFallHeavy;
    case 77:
      return WeatherCondition.snowGrains;
    case 80:
      return WeatherCondition.rainShowersSlight;
    case 81:
      return WeatherCondition.rainShowersModerate;
    case 82:
      return WeatherCondition.rainShowersViolent;
    case 85:
      return WeatherCondition.snowShowersSlight;
    case 86:
      return WeatherCondition.snowShowersHeavy;
    case 95:
      return WeatherCondition.thunderstormSlightOrModerate;
    case 96:
      return WeatherCondition.thunderstormWithHailSlight;
    case 99:
      return WeatherCondition.thunderstormWithHailHeavy;
    default:
      return null;
  }
}

String getWeatherConditionLottiePath(WeatherCondition condition, bool isDay) {
  switch (condition) {
    case WeatherCondition.clearSky:
      if (isDay) return 'assets/lottie/lottie_sunny.json';

      return 'assets/lottie/lottie_clear_night.json';
    case WeatherCondition.mainlyClear:
    case WeatherCondition.partlyCloudy:
      if (isDay) return 'assets/lottie/lottie_partially_sunny.json';

      return 'assets/lottie/lottie_partially_clear_night.json';
    case WeatherCondition.overcast:
      return 'assets/lottie/lottie_cloudy.json';
    case WeatherCondition.fog:
    case WeatherCondition.depositingRimeFog:
      return 'assets/lottie/lottie_foggy.json';
    case WeatherCondition.drizzleLight:
    case WeatherCondition.drizzleModerate:
    case WeatherCondition.drizzleDense:
    case WeatherCondition.freezingDrizzleLight:
    case WeatherCondition.freezingDrizzleDense:
    case WeatherCondition.rainSlight:
    case WeatherCondition.rainModerate:
    case WeatherCondition.rainHeavy:
    case WeatherCondition.rainShowersSlight:
    case WeatherCondition.rainShowersModerate:
    case WeatherCondition.rainShowersViolent:
    case WeatherCondition.freezingRainLight:
    case WeatherCondition.freezingRainHeavy:
      return 'assets/lottie/lottie_rainy.json';
    case WeatherCondition.snowFallSlight:
    case WeatherCondition.snowFallModerate:
    case WeatherCondition.snowFallHeavy:
    case WeatherCondition.snowGrains:
    case WeatherCondition.snowShowersSlight:
    case WeatherCondition.snowShowersHeavy:
      return 'assets/lottie/lottie_snowy.json';
    case WeatherCondition.thunderstormSlightOrModerate:
    case WeatherCondition.thunderstormWithHailSlight:
    case WeatherCondition.thunderstormWithHailHeavy:
      return 'assets/lottie/lottie_thunderstorm.json';
  }
}

String getWeatherConditionLabel(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.clearSky:
      return 'Ciel dégagé';
    case WeatherCondition.mainlyClear:
      return 'Principalement dégagé';
    case WeatherCondition.partlyCloudy:
      return 'Partiellement nuageux';
    case WeatherCondition.overcast:
      return 'Couvert';
    case WeatherCondition.fog:
      return 'Brouillard';
    case WeatherCondition.depositingRimeFog:
      return 'Brouillard givrant';
    case WeatherCondition.drizzleLight:
      return 'Bruine légère';
    case WeatherCondition.drizzleModerate:
      return 'Bruine modérée';
    case WeatherCondition.drizzleDense:
      return 'Bruine dense';
    case WeatherCondition.freezingDrizzleLight:
      return 'Bruine verglaçante légère';
    case WeatherCondition.freezingDrizzleDense:
      return 'Bruine verglaçante dense';
    case WeatherCondition.rainSlight:
      return 'Pluie légère';
    case WeatherCondition.rainModerate:
      return 'Pluie modérée';
    case WeatherCondition.rainHeavy:
      return 'Pluie forte';
    case WeatherCondition.freezingRainLight:
      return 'Pluie verglaçante légère';
    case WeatherCondition.freezingRainHeavy:
      return 'Pluie verglaçante forte';
    case WeatherCondition.snowFallSlight:
      return 'Chute de neige légère';
    case WeatherCondition.snowFallModerate:
      return 'Chute de neige modérée';
    case WeatherCondition.snowFallHeavy:
      return 'Chute de neige forte';
    case WeatherCondition.snowGrains:
      return 'Grains de neige';
    case WeatherCondition.rainShowersSlight:
      return 'Averses de pluie légères';
    case WeatherCondition.rainShowersModerate:
      return 'Averses de pluie modérées';
    case WeatherCondition.rainShowersViolent:
      return 'Averses de pluie violentes';
    case WeatherCondition.snowShowersSlight:
      return 'Averses de neige légères';
    case WeatherCondition.snowShowersHeavy:
      return 'Averses de neige fortes';
    case WeatherCondition.thunderstormSlightOrModerate:
      return 'Orage léger ou modéré';
    case WeatherCondition.thunderstormWithHailSlight:
      return 'Orage avec grêle légère';
    case WeatherCondition.thunderstormWithHailHeavy:
      return 'Orage avec grêle forte';
  }
}
