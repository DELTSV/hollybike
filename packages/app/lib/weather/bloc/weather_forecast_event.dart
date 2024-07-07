import 'package:flutter/foundation.dart';

@immutable
abstract class WeatherForecastEvent {}

class FetchWeatherForecast extends WeatherForecastEvent {
  final double latitude;
  final double longitude;
  final DateTime startDate;
  final DateTime? endDate;

  FetchWeatherForecast({
    required this.latitude,
    required this.longitude,
    required this.startDate,
    this.endDate,
  });
}