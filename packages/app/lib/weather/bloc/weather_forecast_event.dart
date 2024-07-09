import 'package:flutter/foundation.dart';

@immutable
abstract class WeatherForecastEvent {}

class FetchWeatherForecast extends WeatherForecastEvent {
  FetchWeatherForecast();
}