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
      final weatherForecast = await weatherForecastApi.fetchWeatherForecast(
        event.latitude,
        event.longitude,
        DateTime.now(),
        DateTime.now().add(const Duration(days: 3)),
      );

      final groupedWeatherForecast = WeatherForecastGrouped.fromResponse(
        weatherForecast,
      );

      // wait 2 seconds to simulate a slow network

      await Future.delayed(const Duration(seconds: 2));

      emit(WeatherForecastSuccess(state, groupedWeatherForecast));
    } catch (e) {
      emit(WeatherForecastFailure(state, errorMessage: e.toString()));
    }
  }
}
