import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/weather/bloc/weather_forecast_event.dart';
import 'package:hollybike/weather/bloc/weather_forecast_state.dart';
import 'package:hollybike/weather/services/weather_forecast_api.dart';
import 'package:hollybike/weather/types/weather_forecast_grouped.dart';

class WeatherForecastBloc
    extends Bloc<WeatherForecastEvent, WeatherForecastState> {
  final WeatherForecastApi weatherForecastApi;

  WeatherForecastBloc({required this.weatherForecastApi})
      : super(WeatherForecastInitial()) {
    on<FetchWeatherForecast>(_onFetchWeatherForecast);
  }

  void _onFetchWeatherForecast(
    FetchWeatherForecast event,
    Emitter<WeatherForecastState> emit,
  ) async {
    emit(WeatherForecastLoading(state));
    try {
      final startDate = event.startDate.isBefore(DateTime.now())
          ? DateTime.now()
          : event.startDate;

      DateTime endDate = event.endDate ?? startDate;

      if (endDate.difference(startDate).inDays > 5) {
        endDate = startDate.add(const Duration(days: 5));
      }

      final weatherForecast = await weatherForecastApi.fetchWeatherForecast(
        event.latitude,
        event.longitude,
        startDate,
        endDate,
      );

      final groupedWeatherForecast = WeatherForecastGrouped.fromResponse(
        weatherForecast,
      );

      // wait 2 seconds to simulate a slow network

      await Future.delayed(const Duration(seconds: 2));

      emit(WeatherForecastSuccess(state, groupedWeatherForecast));
    } catch (e) {
      log('error occurred', error: e);
      emit(WeatherForecastFailure(state, errorMessage: e.toString()));
    }
  }
}
