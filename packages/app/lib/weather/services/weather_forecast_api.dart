/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/weather/types/weather_forecast_response.dart';

class WeatherForecastApi {
  final String _model;

  WeatherForecastApi({
    String model = 'meteofrance_seamless',
  }) : _model = model;

  final _client = DioClient(host: 'https://api.open-meteo.com/v1');

  Future<WeatherForecastResponse> fetchWeatherForecast(
    double latitude,
    double longitude,
    DateTime startDate,
    DateTime endDate,
  ) async {

    final formattedStartDate = startDate.toIso8601String().split('T')[0];
    final formattedEndDate = endDate.toIso8601String().split('T')[0];

    final response = await _client.dio.get('/forecast', queryParameters: {
      'latitude': latitude,
      'longitude': longitude,
      'hourly': 'temperature_2m,weather_code',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset',
      'timezone': 'Europe/Paris',
      'start_date': formattedStartDate,
      'end_date': formattedEndDate,
      'models': _model,
    });

    return WeatherForecastResponse.fromJson(response.data);
  }
}
