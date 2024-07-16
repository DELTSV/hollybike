/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/foundation.dart';
import 'package:hollybike/weather/types/weather_forecast_grouped.dart';

enum WeatherForecastStatus { loading, success, error, initial }

@immutable
class WeatherForecastState {
  final WeatherForecastStatus status;
  final WeatherForecastGrouped? weatherForecast;

  const WeatherForecastState({
    this.status = WeatherForecastStatus.initial,
    this.weatherForecast,
  });

  WeatherForecastState.state(WeatherForecastState state)
      : this(
          status: state.status,
          weatherForecast: state.weatherForecast,
        );

  WeatherForecastState copyWith({
    WeatherForecastStatus? status,
    WeatherForecastGrouped? weatherForecast,
  }) {
    return WeatherForecastState(
      status: status ?? this.status,
      weatherForecast: weatherForecast ?? this.weatherForecast,
    );
  }
}

class WeatherForecastInitial extends WeatherForecastState {}

class WeatherForecastLoading extends WeatherForecastState {
  WeatherForecastLoading(state)
      : super.state(
          state.copyWith(status: WeatherForecastStatus.loading),
        );
}

class WeatherForecastSuccess extends WeatherForecastState {
  WeatherForecastSuccess(state)
      : super.state(
          state.copyWith(status: WeatherForecastStatus.success),
        );
}

class WeatherForecastFailure extends WeatherForecastState {
  final String errorMessage;

  WeatherForecastFailure(state, {required this.errorMessage})
      : super.state(
          state.copyWith(status: WeatherForecastStatus.error),
        );
}
