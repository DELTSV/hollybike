import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/shared/types/position.dart';
import 'package:hollybike/weather/bloc/weather_forecast_event.dart';
import 'package:hollybike/weather/bloc/weather_forecast_state.dart';
import 'package:hollybike/weather/services/weather_forecast_api.dart';
import 'package:hollybike/weather/types/weather_forecast_grouped.dart';

class WeatherForecastBloc
    extends Bloc<WeatherForecastEvent, WeatherForecastState> {
  final DateTime startDate;
  final DateTime? endDate;
  final Position destination;
  final WeatherForecastApi weatherForecastApi;

  WeatherForecastBloc({
    required this.weatherForecastApi,
    required this.startDate,
    required this.destination,
    this.endDate,
  }) : super(WeatherForecastInitial()) {
    on<FetchWeatherForecast>(_onFetchWeatherForecast);
  }

  void _onFetchWeatherForecast(
    FetchWeatherForecast event,
    Emitter<WeatherForecastState> emit,
  ) async {
    emit(WeatherForecastLoading(state));
    try {
      final startDate = this.startDate.isBefore(DateTime.now())
          ? DateTime.now()
          : this.startDate;

      DateTime endDate = this.endDate ?? startDate;

      if (endDate.difference(startDate).inDays > 5) {
        endDate = startDate.add(const Duration(days: 5));
      }

      final weatherForecast = await weatherForecastApi.fetchWeatherForecast(
        destination.latitude,
        destination.longitude,
        startDate,
        endDate,
      );

      final groupedWeatherForecast = WeatherForecastGrouped.fromResponse(
        weatherForecast,
      );

      if (groupedWeatherForecast.dailyWeather.isEmpty) {
        emit(WeatherForecastFailure(state, errorMessage: 'Aucune donnée'));
        return;
      }

      emit(WeatherForecastSuccess(
        state.copyWith(weatherForecast: groupedWeatherForecast),
      ));
    } catch (e) {
      log('error occurred', error: e);
      emit(WeatherForecastFailure(state, errorMessage: e.toString()));
    }
  }
}

extension FirstWhenNotLoading on WeatherForecastBloc {
  Future<WeatherForecastState> get firstWhenNotLoading async {
    return stream.firstWhere((state) {
      return state is! WeatherForecastLoading;
    });
  }
}
