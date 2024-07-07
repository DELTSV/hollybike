
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/weather/types/weather_forecast_response.dart';
import 'package:intl/intl.dart';

part 'weather_forecast_grouped.freezed.dart';

@freezed
class WeatherForecastGrouped with _$WeatherForecastGrouped {
  const factory WeatherForecastGrouped({
    required List<DailyWeatherGrouped> dailyWeather,
  }) = _WeatherForecastGrouped;

  factory WeatherForecastGrouped.fromResponse(WeatherForecastResponse response) {
    // Group hourly data by day
    final Map<String, List<HourlyWeather>> groupedHourly = {};
    for (int i = 0; i < response.hourly.time.length; i++) {
      final dateTime = DateTime.parse(response.hourly.time[i]);
      final date = DateFormat('yyyy-MM-dd').format(dateTime);
      final hour = DateFormat('HH:mm').format(dateTime);

      final hourlyWeather = HourlyWeather(
        time: hour,
        temperature: response.hourly.temperature2m[i] != null
            ? '${response.hourly.temperature2m[i]}${response.hourlyUnits.temperature2m}'
            : null,
        weatherCode: response.hourly.weatherCode[i],
      );

      groupedHourly.putIfAbsent(date, () => []).add(hourlyWeather);
    }

    // Group daily data
    final List<DailyWeatherGrouped> groupedDaily = [];
    for (int i = 0; i < response.daily.time.length; i++) {
      final dailyWeatherGrouped = DailyWeatherGrouped(
        date: response.daily.time[i],
        maxTemperature: '${response.daily.temperature2mMax[i]}${response.dailyUnits.temperature2mMax}',
        minTemperature: '${response.daily.temperature2mMin[i]}${response.dailyUnits.temperature2mMin}',
        weatherCode: response.daily.weatherCode[i],
        hourlyWeather: groupedHourly[response.daily.time[i]] ?? [],
      );
      groupedDaily.add(dailyWeatherGrouped);
    }

    return WeatherForecastGrouped(dailyWeather: groupedDaily);
  }
}

@freezed
class DailyWeatherGrouped with _$DailyWeatherGrouped {
  const factory DailyWeatherGrouped({
    required String date,
    required String maxTemperature,
    required String minTemperature,
    required int weatherCode,
    required List<HourlyWeather> hourlyWeather,
  }) = _DailyWeatherGrouped;
}

@freezed
class HourlyWeather with _$HourlyWeather {
  const factory HourlyWeather({
    required String time,
    required String? temperature,
    required int? weatherCode,
  }) = _HourlyWeather;
}