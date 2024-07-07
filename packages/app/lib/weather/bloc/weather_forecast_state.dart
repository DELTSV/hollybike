import 'package:flutter/foundation.dart';
import 'package:hollybike/weather/types/weather_forecast_grouped.dart';


enum WeatherForecastStatus { loading, success, error, initial }

@immutable
class WeatherForecastState {
  final WeatherForecastStatus status;

  const WeatherForecastState({
    this.status = WeatherForecastStatus.initial,
  });

  WeatherForecastState.state(WeatherForecastState state)
      : this(
    status: state.status,
  );

  WeatherForecastState copyWith({
    WeatherForecastStatus? status,
  }) {
    return WeatherForecastState(
      status: status ?? this.status,
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
  final WeatherForecastGrouped weatherForecast;

  WeatherForecastSuccess(state, this.weatherForecast)
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