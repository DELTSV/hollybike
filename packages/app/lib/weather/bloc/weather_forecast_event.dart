/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/foundation.dart';

@immutable
abstract class WeatherForecastEvent {}

class FetchWeatherForecast extends WeatherForecastEvent {
  FetchWeatherForecast();
}