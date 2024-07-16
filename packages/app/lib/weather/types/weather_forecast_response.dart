/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_forecast_response.freezed.dart';
part 'weather_forecast_response.g.dart';

@freezed
class WeatherForecastResponse with _$WeatherForecastResponse {
  const factory WeatherForecastResponse({
    required double latitude,
    required double longitude,
    @JsonKey(name: 'generationtime_ms') required double generationTimeMs,
    @JsonKey(name: 'utc_offset_seconds') required int utcOffsetSeconds,
    required String timezone,
    @JsonKey(name: 'timezone_abbreviation') required String timezoneAbbreviation,
    required double elevation,
    @JsonKey(name: 'hourly_units') required HourlyUnits hourlyUnits,
    required Hourly hourly,
    @JsonKey(name: 'daily_units') required DailyUnits dailyUnits,
    required Daily daily,
  }) = _WeatherForecastResponse;

  factory WeatherForecastResponse.fromJson(Map<String, dynamic> json) => _$WeatherForecastResponseFromJson(json);
}

@freezed
class HourlyUnits with _$HourlyUnits {
  const factory HourlyUnits({
    required String time,
    @JsonKey(name: 'temperature_2m') required String temperature2m,
    @JsonKey(name: 'weather_code') required String weatherCode,
  }) = _HourlyUnits;

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => _$HourlyUnitsFromJson(json);
}

@freezed
class Hourly with _$Hourly {
  const factory Hourly({
    required List<String> time,
    @JsonKey(name: 'temperature_2m') required List<double?> temperature2m,
    @JsonKey(name: 'weather_code') required List<int?> weatherCode,
  }) = _Hourly;

  factory Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);
}

@freezed
class DailyUnits with _$DailyUnits {
  const factory DailyUnits({
    required String time,
    @JsonKey(name: 'weather_code') required String weatherCode,
    @JsonKey(name: 'temperature_2m_max') required String temperature2mMax,
    @JsonKey(name: 'temperature_2m_min') required String temperature2mMin,
    @JsonKey(name: 'sunrise') required String sunrise,
    @JsonKey(name: 'sunset') required String sunset,
  }) = _DailyUnits;

  factory DailyUnits.fromJson(Map<String, dynamic> json) => _$DailyUnitsFromJson(json);
}

@freezed
class Daily with _$Daily {
  const factory Daily({
    required List<String> time,
    @JsonKey(name: 'weather_code') required List<int?> weatherCode,
    @JsonKey(name: 'temperature_2m_max') required List<double?> temperature2mMax,
    @JsonKey(name: 'temperature_2m_min') required List<double?> temperature2mMin,
    @JsonKey(name: 'sunrise') required List<String?> sunrise,
    @JsonKey(name: 'sunset') required List<String?> sunset,
  }) = _Daily;

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);
}