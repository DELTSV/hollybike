// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_forecast_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeatherForecastResponse _$WeatherForecastResponseFromJson(
    Map<String, dynamic> json) {
  return _WeatherForecastResponse.fromJson(json);
}

/// @nodoc
mixin _$WeatherForecastResponse {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'generationtime_ms')
  double get generationTimeMs => throw _privateConstructorUsedError;
  @JsonKey(name: 'utc_offset_seconds')
  int get utcOffsetSeconds => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;
  @JsonKey(name: 'timezone_abbreviation')
  String get timezoneAbbreviation => throw _privateConstructorUsedError;
  double get elevation => throw _privateConstructorUsedError;
  @JsonKey(name: 'hourly_units')
  HourlyUnits get hourlyUnits => throw _privateConstructorUsedError;
  Hourly get hourly => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_units')
  DailyUnits get dailyUnits => throw _privateConstructorUsedError;
  Daily get daily => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeatherForecastResponseCopyWith<WeatherForecastResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherForecastResponseCopyWith<$Res> {
  factory $WeatherForecastResponseCopyWith(WeatherForecastResponse value,
          $Res Function(WeatherForecastResponse) then) =
      _$WeatherForecastResponseCopyWithImpl<$Res, WeatherForecastResponse>;
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      @JsonKey(name: 'generationtime_ms') double generationTimeMs,
      @JsonKey(name: 'utc_offset_seconds') int utcOffsetSeconds,
      String timezone,
      @JsonKey(name: 'timezone_abbreviation') String timezoneAbbreviation,
      double elevation,
      @JsonKey(name: 'hourly_units') HourlyUnits hourlyUnits,
      Hourly hourly,
      @JsonKey(name: 'daily_units') DailyUnits dailyUnits,
      Daily daily});

  $HourlyUnitsCopyWith<$Res> get hourlyUnits;
  $HourlyCopyWith<$Res> get hourly;
  $DailyUnitsCopyWith<$Res> get dailyUnits;
  $DailyCopyWith<$Res> get daily;
}

/// @nodoc
class _$WeatherForecastResponseCopyWithImpl<$Res,
        $Val extends WeatherForecastResponse>
    implements $WeatherForecastResponseCopyWith<$Res> {
  _$WeatherForecastResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? generationTimeMs = null,
    Object? utcOffsetSeconds = null,
    Object? timezone = null,
    Object? timezoneAbbreviation = null,
    Object? elevation = null,
    Object? hourlyUnits = null,
    Object? hourly = null,
    Object? dailyUnits = null,
    Object? daily = null,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      generationTimeMs: null == generationTimeMs
          ? _value.generationTimeMs
          : generationTimeMs // ignore: cast_nullable_to_non_nullable
              as double,
      utcOffsetSeconds: null == utcOffsetSeconds
          ? _value.utcOffsetSeconds
          : utcOffsetSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      timezoneAbbreviation: null == timezoneAbbreviation
          ? _value.timezoneAbbreviation
          : timezoneAbbreviation // ignore: cast_nullable_to_non_nullable
              as String,
      elevation: null == elevation
          ? _value.elevation
          : elevation // ignore: cast_nullable_to_non_nullable
              as double,
      hourlyUnits: null == hourlyUnits
          ? _value.hourlyUnits
          : hourlyUnits // ignore: cast_nullable_to_non_nullable
              as HourlyUnits,
      hourly: null == hourly
          ? _value.hourly
          : hourly // ignore: cast_nullable_to_non_nullable
              as Hourly,
      dailyUnits: null == dailyUnits
          ? _value.dailyUnits
          : dailyUnits // ignore: cast_nullable_to_non_nullable
              as DailyUnits,
      daily: null == daily
          ? _value.daily
          : daily // ignore: cast_nullable_to_non_nullable
              as Daily,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HourlyUnitsCopyWith<$Res> get hourlyUnits {
    return $HourlyUnitsCopyWith<$Res>(_value.hourlyUnits, (value) {
      return _then(_value.copyWith(hourlyUnits: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $HourlyCopyWith<$Res> get hourly {
    return $HourlyCopyWith<$Res>(_value.hourly, (value) {
      return _then(_value.copyWith(hourly: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DailyUnitsCopyWith<$Res> get dailyUnits {
    return $DailyUnitsCopyWith<$Res>(_value.dailyUnits, (value) {
      return _then(_value.copyWith(dailyUnits: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DailyCopyWith<$Res> get daily {
    return $DailyCopyWith<$Res>(_value.daily, (value) {
      return _then(_value.copyWith(daily: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WeatherForecastResponseImplCopyWith<$Res>
    implements $WeatherForecastResponseCopyWith<$Res> {
  factory _$$WeatherForecastResponseImplCopyWith(
          _$WeatherForecastResponseImpl value,
          $Res Function(_$WeatherForecastResponseImpl) then) =
      __$$WeatherForecastResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      @JsonKey(name: 'generationtime_ms') double generationTimeMs,
      @JsonKey(name: 'utc_offset_seconds') int utcOffsetSeconds,
      String timezone,
      @JsonKey(name: 'timezone_abbreviation') String timezoneAbbreviation,
      double elevation,
      @JsonKey(name: 'hourly_units') HourlyUnits hourlyUnits,
      Hourly hourly,
      @JsonKey(name: 'daily_units') DailyUnits dailyUnits,
      Daily daily});

  @override
  $HourlyUnitsCopyWith<$Res> get hourlyUnits;
  @override
  $HourlyCopyWith<$Res> get hourly;
  @override
  $DailyUnitsCopyWith<$Res> get dailyUnits;
  @override
  $DailyCopyWith<$Res> get daily;
}

/// @nodoc
class __$$WeatherForecastResponseImplCopyWithImpl<$Res>
    extends _$WeatherForecastResponseCopyWithImpl<$Res,
        _$WeatherForecastResponseImpl>
    implements _$$WeatherForecastResponseImplCopyWith<$Res> {
  __$$WeatherForecastResponseImplCopyWithImpl(
      _$WeatherForecastResponseImpl _value,
      $Res Function(_$WeatherForecastResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? generationTimeMs = null,
    Object? utcOffsetSeconds = null,
    Object? timezone = null,
    Object? timezoneAbbreviation = null,
    Object? elevation = null,
    Object? hourlyUnits = null,
    Object? hourly = null,
    Object? dailyUnits = null,
    Object? daily = null,
  }) {
    return _then(_$WeatherForecastResponseImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      generationTimeMs: null == generationTimeMs
          ? _value.generationTimeMs
          : generationTimeMs // ignore: cast_nullable_to_non_nullable
              as double,
      utcOffsetSeconds: null == utcOffsetSeconds
          ? _value.utcOffsetSeconds
          : utcOffsetSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      timezoneAbbreviation: null == timezoneAbbreviation
          ? _value.timezoneAbbreviation
          : timezoneAbbreviation // ignore: cast_nullable_to_non_nullable
              as String,
      elevation: null == elevation
          ? _value.elevation
          : elevation // ignore: cast_nullable_to_non_nullable
              as double,
      hourlyUnits: null == hourlyUnits
          ? _value.hourlyUnits
          : hourlyUnits // ignore: cast_nullable_to_non_nullable
              as HourlyUnits,
      hourly: null == hourly
          ? _value.hourly
          : hourly // ignore: cast_nullable_to_non_nullable
              as Hourly,
      dailyUnits: null == dailyUnits
          ? _value.dailyUnits
          : dailyUnits // ignore: cast_nullable_to_non_nullable
              as DailyUnits,
      daily: null == daily
          ? _value.daily
          : daily // ignore: cast_nullable_to_non_nullable
              as Daily,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeatherForecastResponseImpl implements _WeatherForecastResponse {
  const _$WeatherForecastResponseImpl(
      {required this.latitude,
      required this.longitude,
      @JsonKey(name: 'generationtime_ms') required this.generationTimeMs,
      @JsonKey(name: 'utc_offset_seconds') required this.utcOffsetSeconds,
      required this.timezone,
      @JsonKey(name: 'timezone_abbreviation')
      required this.timezoneAbbreviation,
      required this.elevation,
      @JsonKey(name: 'hourly_units') required this.hourlyUnits,
      required this.hourly,
      @JsonKey(name: 'daily_units') required this.dailyUnits,
      required this.daily});

  factory _$WeatherForecastResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeatherForecastResponseImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  @JsonKey(name: 'generationtime_ms')
  final double generationTimeMs;
  @override
  @JsonKey(name: 'utc_offset_seconds')
  final int utcOffsetSeconds;
  @override
  final String timezone;
  @override
  @JsonKey(name: 'timezone_abbreviation')
  final String timezoneAbbreviation;
  @override
  final double elevation;
  @override
  @JsonKey(name: 'hourly_units')
  final HourlyUnits hourlyUnits;
  @override
  final Hourly hourly;
  @override
  @JsonKey(name: 'daily_units')
  final DailyUnits dailyUnits;
  @override
  final Daily daily;

  @override
  String toString() {
    return 'WeatherForecastResponse(latitude: $latitude, longitude: $longitude, generationTimeMs: $generationTimeMs, utcOffsetSeconds: $utcOffsetSeconds, timezone: $timezone, timezoneAbbreviation: $timezoneAbbreviation, elevation: $elevation, hourlyUnits: $hourlyUnits, hourly: $hourly, dailyUnits: $dailyUnits, daily: $daily)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherForecastResponseImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.generationTimeMs, generationTimeMs) ||
                other.generationTimeMs == generationTimeMs) &&
            (identical(other.utcOffsetSeconds, utcOffsetSeconds) ||
                other.utcOffsetSeconds == utcOffsetSeconds) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.timezoneAbbreviation, timezoneAbbreviation) ||
                other.timezoneAbbreviation == timezoneAbbreviation) &&
            (identical(other.elevation, elevation) ||
                other.elevation == elevation) &&
            (identical(other.hourlyUnits, hourlyUnits) ||
                other.hourlyUnits == hourlyUnits) &&
            (identical(other.hourly, hourly) || other.hourly == hourly) &&
            (identical(other.dailyUnits, dailyUnits) ||
                other.dailyUnits == dailyUnits) &&
            (identical(other.daily, daily) || other.daily == daily));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      latitude,
      longitude,
      generationTimeMs,
      utcOffsetSeconds,
      timezone,
      timezoneAbbreviation,
      elevation,
      hourlyUnits,
      hourly,
      dailyUnits,
      daily);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherForecastResponseImplCopyWith<_$WeatherForecastResponseImpl>
      get copyWith => __$$WeatherForecastResponseImplCopyWithImpl<
          _$WeatherForecastResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeatherForecastResponseImplToJson(
      this,
    );
  }
}

abstract class _WeatherForecastResponse implements WeatherForecastResponse {
  const factory _WeatherForecastResponse(
      {required final double latitude,
      required final double longitude,
      @JsonKey(name: 'generationtime_ms')
      required final double generationTimeMs,
      @JsonKey(name: 'utc_offset_seconds') required final int utcOffsetSeconds,
      required final String timezone,
      @JsonKey(name: 'timezone_abbreviation')
      required final String timezoneAbbreviation,
      required final double elevation,
      @JsonKey(name: 'hourly_units') required final HourlyUnits hourlyUnits,
      required final Hourly hourly,
      @JsonKey(name: 'daily_units') required final DailyUnits dailyUnits,
      required final Daily daily}) = _$WeatherForecastResponseImpl;

  factory _WeatherForecastResponse.fromJson(Map<String, dynamic> json) =
      _$WeatherForecastResponseImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(name: 'generationtime_ms')
  double get generationTimeMs;
  @override
  @JsonKey(name: 'utc_offset_seconds')
  int get utcOffsetSeconds;
  @override
  String get timezone;
  @override
  @JsonKey(name: 'timezone_abbreviation')
  String get timezoneAbbreviation;
  @override
  double get elevation;
  @override
  @JsonKey(name: 'hourly_units')
  HourlyUnits get hourlyUnits;
  @override
  Hourly get hourly;
  @override
  @JsonKey(name: 'daily_units')
  DailyUnits get dailyUnits;
  @override
  Daily get daily;
  @override
  @JsonKey(ignore: true)
  _$$WeatherForecastResponseImplCopyWith<_$WeatherForecastResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

HourlyUnits _$HourlyUnitsFromJson(Map<String, dynamic> json) {
  return _HourlyUnits.fromJson(json);
}

/// @nodoc
mixin _$HourlyUnits {
  String get time => throw _privateConstructorUsedError;
  @JsonKey(name: 'temperature_2m')
  String get temperature2m => throw _privateConstructorUsedError;
  @JsonKey(name: 'weather_code')
  String get weatherCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HourlyUnitsCopyWith<HourlyUnits> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HourlyUnitsCopyWith<$Res> {
  factory $HourlyUnitsCopyWith(
          HourlyUnits value, $Res Function(HourlyUnits) then) =
      _$HourlyUnitsCopyWithImpl<$Res, HourlyUnits>;
  @useResult
  $Res call(
      {String time,
      @JsonKey(name: 'temperature_2m') String temperature2m,
      @JsonKey(name: 'weather_code') String weatherCode});
}

/// @nodoc
class _$HourlyUnitsCopyWithImpl<$Res, $Val extends HourlyUnits>
    implements $HourlyUnitsCopyWith<$Res> {
  _$HourlyUnitsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? temperature2m = null,
    Object? weatherCode = null,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      temperature2m: null == temperature2m
          ? _value.temperature2m
          : temperature2m // ignore: cast_nullable_to_non_nullable
              as String,
      weatherCode: null == weatherCode
          ? _value.weatherCode
          : weatherCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HourlyUnitsImplCopyWith<$Res>
    implements $HourlyUnitsCopyWith<$Res> {
  factory _$$HourlyUnitsImplCopyWith(
          _$HourlyUnitsImpl value, $Res Function(_$HourlyUnitsImpl) then) =
      __$$HourlyUnitsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String time,
      @JsonKey(name: 'temperature_2m') String temperature2m,
      @JsonKey(name: 'weather_code') String weatherCode});
}

/// @nodoc
class __$$HourlyUnitsImplCopyWithImpl<$Res>
    extends _$HourlyUnitsCopyWithImpl<$Res, _$HourlyUnitsImpl>
    implements _$$HourlyUnitsImplCopyWith<$Res> {
  __$$HourlyUnitsImplCopyWithImpl(
      _$HourlyUnitsImpl _value, $Res Function(_$HourlyUnitsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? temperature2m = null,
    Object? weatherCode = null,
  }) {
    return _then(_$HourlyUnitsImpl(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      temperature2m: null == temperature2m
          ? _value.temperature2m
          : temperature2m // ignore: cast_nullable_to_non_nullable
              as String,
      weatherCode: null == weatherCode
          ? _value.weatherCode
          : weatherCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HourlyUnitsImpl implements _HourlyUnits {
  const _$HourlyUnitsImpl(
      {required this.time,
      @JsonKey(name: 'temperature_2m') required this.temperature2m,
      @JsonKey(name: 'weather_code') required this.weatherCode});

  factory _$HourlyUnitsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HourlyUnitsImplFromJson(json);

  @override
  final String time;
  @override
  @JsonKey(name: 'temperature_2m')
  final String temperature2m;
  @override
  @JsonKey(name: 'weather_code')
  final String weatherCode;

  @override
  String toString() {
    return 'HourlyUnits(time: $time, temperature2m: $temperature2m, weatherCode: $weatherCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HourlyUnitsImpl &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.temperature2m, temperature2m) ||
                other.temperature2m == temperature2m) &&
            (identical(other.weatherCode, weatherCode) ||
                other.weatherCode == weatherCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, time, temperature2m, weatherCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HourlyUnitsImplCopyWith<_$HourlyUnitsImpl> get copyWith =>
      __$$HourlyUnitsImplCopyWithImpl<_$HourlyUnitsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HourlyUnitsImplToJson(
      this,
    );
  }
}

abstract class _HourlyUnits implements HourlyUnits {
  const factory _HourlyUnits(
          {required final String time,
          @JsonKey(name: 'temperature_2m') required final String temperature2m,
          @JsonKey(name: 'weather_code') required final String weatherCode}) =
      _$HourlyUnitsImpl;

  factory _HourlyUnits.fromJson(Map<String, dynamic> json) =
      _$HourlyUnitsImpl.fromJson;

  @override
  String get time;
  @override
  @JsonKey(name: 'temperature_2m')
  String get temperature2m;
  @override
  @JsonKey(name: 'weather_code')
  String get weatherCode;
  @override
  @JsonKey(ignore: true)
  _$$HourlyUnitsImplCopyWith<_$HourlyUnitsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Hourly _$HourlyFromJson(Map<String, dynamic> json) {
  return _Hourly.fromJson(json);
}

/// @nodoc
mixin _$Hourly {
  List<String> get time => throw _privateConstructorUsedError;
  @JsonKey(name: 'temperature_2m')
  List<double?> get temperature2m => throw _privateConstructorUsedError;
  @JsonKey(name: 'weather_code')
  List<int?> get weatherCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HourlyCopyWith<Hourly> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HourlyCopyWith<$Res> {
  factory $HourlyCopyWith(Hourly value, $Res Function(Hourly) then) =
      _$HourlyCopyWithImpl<$Res, Hourly>;
  @useResult
  $Res call(
      {List<String> time,
      @JsonKey(name: 'temperature_2m') List<double?> temperature2m,
      @JsonKey(name: 'weather_code') List<int?> weatherCode});
}

/// @nodoc
class _$HourlyCopyWithImpl<$Res, $Val extends Hourly>
    implements $HourlyCopyWith<$Res> {
  _$HourlyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? temperature2m = null,
    Object? weatherCode = null,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as List<String>,
      temperature2m: null == temperature2m
          ? _value.temperature2m
          : temperature2m // ignore: cast_nullable_to_non_nullable
              as List<double?>,
      weatherCode: null == weatherCode
          ? _value.weatherCode
          : weatherCode // ignore: cast_nullable_to_non_nullable
              as List<int?>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HourlyImplCopyWith<$Res> implements $HourlyCopyWith<$Res> {
  factory _$$HourlyImplCopyWith(
          _$HourlyImpl value, $Res Function(_$HourlyImpl) then) =
      __$$HourlyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> time,
      @JsonKey(name: 'temperature_2m') List<double?> temperature2m,
      @JsonKey(name: 'weather_code') List<int?> weatherCode});
}

/// @nodoc
class __$$HourlyImplCopyWithImpl<$Res>
    extends _$HourlyCopyWithImpl<$Res, _$HourlyImpl>
    implements _$$HourlyImplCopyWith<$Res> {
  __$$HourlyImplCopyWithImpl(
      _$HourlyImpl _value, $Res Function(_$HourlyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? temperature2m = null,
    Object? weatherCode = null,
  }) {
    return _then(_$HourlyImpl(
      time: null == time
          ? _value._time
          : time // ignore: cast_nullable_to_non_nullable
              as List<String>,
      temperature2m: null == temperature2m
          ? _value._temperature2m
          : temperature2m // ignore: cast_nullable_to_non_nullable
              as List<double?>,
      weatherCode: null == weatherCode
          ? _value._weatherCode
          : weatherCode // ignore: cast_nullable_to_non_nullable
              as List<int?>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HourlyImpl implements _Hourly {
  const _$HourlyImpl(
      {required final List<String> time,
      @JsonKey(name: 'temperature_2m')
      required final List<double?> temperature2m,
      @JsonKey(name: 'weather_code') required final List<int?> weatherCode})
      : _time = time,
        _temperature2m = temperature2m,
        _weatherCode = weatherCode;

  factory _$HourlyImpl.fromJson(Map<String, dynamic> json) =>
      _$$HourlyImplFromJson(json);

  final List<String> _time;
  @override
  List<String> get time {
    if (_time is EqualUnmodifiableListView) return _time;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_time);
  }

  final List<double?> _temperature2m;
  @override
  @JsonKey(name: 'temperature_2m')
  List<double?> get temperature2m {
    if (_temperature2m is EqualUnmodifiableListView) return _temperature2m;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_temperature2m);
  }

  final List<int?> _weatherCode;
  @override
  @JsonKey(name: 'weather_code')
  List<int?> get weatherCode {
    if (_weatherCode is EqualUnmodifiableListView) return _weatherCode;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weatherCode);
  }

  @override
  String toString() {
    return 'Hourly(time: $time, temperature2m: $temperature2m, weatherCode: $weatherCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HourlyImpl &&
            const DeepCollectionEquality().equals(other._time, _time) &&
            const DeepCollectionEquality()
                .equals(other._temperature2m, _temperature2m) &&
            const DeepCollectionEquality()
                .equals(other._weatherCode, _weatherCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_time),
      const DeepCollectionEquality().hash(_temperature2m),
      const DeepCollectionEquality().hash(_weatherCode));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HourlyImplCopyWith<_$HourlyImpl> get copyWith =>
      __$$HourlyImplCopyWithImpl<_$HourlyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HourlyImplToJson(
      this,
    );
  }
}

abstract class _Hourly implements Hourly {
  const factory _Hourly(
      {required final List<String> time,
      @JsonKey(name: 'temperature_2m')
      required final List<double?> temperature2m,
      @JsonKey(name: 'weather_code')
      required final List<int?> weatherCode}) = _$HourlyImpl;

  factory _Hourly.fromJson(Map<String, dynamic> json) = _$HourlyImpl.fromJson;

  @override
  List<String> get time;
  @override
  @JsonKey(name: 'temperature_2m')
  List<double?> get temperature2m;
  @override
  @JsonKey(name: 'weather_code')
  List<int?> get weatherCode;
  @override
  @JsonKey(ignore: true)
  _$$HourlyImplCopyWith<_$HourlyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyUnits _$DailyUnitsFromJson(Map<String, dynamic> json) {
  return _DailyUnits.fromJson(json);
}

/// @nodoc
mixin _$DailyUnits {
  String get time => throw _privateConstructorUsedError;
  @JsonKey(name: 'weather_code')
  String get weatherCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'temperature_2m_max')
  String get temperature2mMax => throw _privateConstructorUsedError;
  @JsonKey(name: 'temperature_2m_min')
  String get temperature2mMin => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyUnitsCopyWith<DailyUnits> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyUnitsCopyWith<$Res> {
  factory $DailyUnitsCopyWith(
          DailyUnits value, $Res Function(DailyUnits) then) =
      _$DailyUnitsCopyWithImpl<$Res, DailyUnits>;
  @useResult
  $Res call(
      {String time,
      @JsonKey(name: 'weather_code') String weatherCode,
      @JsonKey(name: 'temperature_2m_max') String temperature2mMax,
      @JsonKey(name: 'temperature_2m_min') String temperature2mMin});
}

/// @nodoc
class _$DailyUnitsCopyWithImpl<$Res, $Val extends DailyUnits>
    implements $DailyUnitsCopyWith<$Res> {
  _$DailyUnitsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? weatherCode = null,
    Object? temperature2mMax = null,
    Object? temperature2mMin = null,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      weatherCode: null == weatherCode
          ? _value.weatherCode
          : weatherCode // ignore: cast_nullable_to_non_nullable
              as String,
      temperature2mMax: null == temperature2mMax
          ? _value.temperature2mMax
          : temperature2mMax // ignore: cast_nullable_to_non_nullable
              as String,
      temperature2mMin: null == temperature2mMin
          ? _value.temperature2mMin
          : temperature2mMin // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyUnitsImplCopyWith<$Res>
    implements $DailyUnitsCopyWith<$Res> {
  factory _$$DailyUnitsImplCopyWith(
          _$DailyUnitsImpl value, $Res Function(_$DailyUnitsImpl) then) =
      __$$DailyUnitsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String time,
      @JsonKey(name: 'weather_code') String weatherCode,
      @JsonKey(name: 'temperature_2m_max') String temperature2mMax,
      @JsonKey(name: 'temperature_2m_min') String temperature2mMin});
}

/// @nodoc
class __$$DailyUnitsImplCopyWithImpl<$Res>
    extends _$DailyUnitsCopyWithImpl<$Res, _$DailyUnitsImpl>
    implements _$$DailyUnitsImplCopyWith<$Res> {
  __$$DailyUnitsImplCopyWithImpl(
      _$DailyUnitsImpl _value, $Res Function(_$DailyUnitsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? weatherCode = null,
    Object? temperature2mMax = null,
    Object? temperature2mMin = null,
  }) {
    return _then(_$DailyUnitsImpl(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      weatherCode: null == weatherCode
          ? _value.weatherCode
          : weatherCode // ignore: cast_nullable_to_non_nullable
              as String,
      temperature2mMax: null == temperature2mMax
          ? _value.temperature2mMax
          : temperature2mMax // ignore: cast_nullable_to_non_nullable
              as String,
      temperature2mMin: null == temperature2mMin
          ? _value.temperature2mMin
          : temperature2mMin // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyUnitsImpl implements _DailyUnits {
  const _$DailyUnitsImpl(
      {required this.time,
      @JsonKey(name: 'weather_code') required this.weatherCode,
      @JsonKey(name: 'temperature_2m_max') required this.temperature2mMax,
      @JsonKey(name: 'temperature_2m_min') required this.temperature2mMin});

  factory _$DailyUnitsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyUnitsImplFromJson(json);

  @override
  final String time;
  @override
  @JsonKey(name: 'weather_code')
  final String weatherCode;
  @override
  @JsonKey(name: 'temperature_2m_max')
  final String temperature2mMax;
  @override
  @JsonKey(name: 'temperature_2m_min')
  final String temperature2mMin;

  @override
  String toString() {
    return 'DailyUnits(time: $time, weatherCode: $weatherCode, temperature2mMax: $temperature2mMax, temperature2mMin: $temperature2mMin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyUnitsImpl &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.weatherCode, weatherCode) ||
                other.weatherCode == weatherCode) &&
            (identical(other.temperature2mMax, temperature2mMax) ||
                other.temperature2mMax == temperature2mMax) &&
            (identical(other.temperature2mMin, temperature2mMin) ||
                other.temperature2mMin == temperature2mMin));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, time, weatherCode, temperature2mMax, temperature2mMin);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyUnitsImplCopyWith<_$DailyUnitsImpl> get copyWith =>
      __$$DailyUnitsImplCopyWithImpl<_$DailyUnitsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyUnitsImplToJson(
      this,
    );
  }
}

abstract class _DailyUnits implements DailyUnits {
  const factory _DailyUnits(
      {required final String time,
      @JsonKey(name: 'weather_code') required final String weatherCode,
      @JsonKey(name: 'temperature_2m_max')
      required final String temperature2mMax,
      @JsonKey(name: 'temperature_2m_min')
      required final String temperature2mMin}) = _$DailyUnitsImpl;

  factory _DailyUnits.fromJson(Map<String, dynamic> json) =
      _$DailyUnitsImpl.fromJson;

  @override
  String get time;
  @override
  @JsonKey(name: 'weather_code')
  String get weatherCode;
  @override
  @JsonKey(name: 'temperature_2m_max')
  String get temperature2mMax;
  @override
  @JsonKey(name: 'temperature_2m_min')
  String get temperature2mMin;
  @override
  @JsonKey(ignore: true)
  _$$DailyUnitsImplCopyWith<_$DailyUnitsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Daily _$DailyFromJson(Map<String, dynamic> json) {
  return _Daily.fromJson(json);
}

/// @nodoc
mixin _$Daily {
  List<String> get time => throw _privateConstructorUsedError;
  @JsonKey(name: 'weather_code')
  List<int?> get weatherCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'temperature_2m_max')
  List<double?> get temperature2mMax => throw _privateConstructorUsedError;
  @JsonKey(name: 'temperature_2m_min')
  List<double?> get temperature2mMin => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyCopyWith<Daily> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyCopyWith<$Res> {
  factory $DailyCopyWith(Daily value, $Res Function(Daily) then) =
      _$DailyCopyWithImpl<$Res, Daily>;
  @useResult
  $Res call(
      {List<String> time,
      @JsonKey(name: 'weather_code') List<int?> weatherCode,
      @JsonKey(name: 'temperature_2m_max') List<double?> temperature2mMax,
      @JsonKey(name: 'temperature_2m_min') List<double?> temperature2mMin});
}

/// @nodoc
class _$DailyCopyWithImpl<$Res, $Val extends Daily>
    implements $DailyCopyWith<$Res> {
  _$DailyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? weatherCode = null,
    Object? temperature2mMax = null,
    Object? temperature2mMin = null,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weatherCode: null == weatherCode
          ? _value.weatherCode
          : weatherCode // ignore: cast_nullable_to_non_nullable
              as List<int?>,
      temperature2mMax: null == temperature2mMax
          ? _value.temperature2mMax
          : temperature2mMax // ignore: cast_nullable_to_non_nullable
              as List<double?>,
      temperature2mMin: null == temperature2mMin
          ? _value.temperature2mMin
          : temperature2mMin // ignore: cast_nullable_to_non_nullable
              as List<double?>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyImplCopyWith<$Res> implements $DailyCopyWith<$Res> {
  factory _$$DailyImplCopyWith(
          _$DailyImpl value, $Res Function(_$DailyImpl) then) =
      __$$DailyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> time,
      @JsonKey(name: 'weather_code') List<int?> weatherCode,
      @JsonKey(name: 'temperature_2m_max') List<double?> temperature2mMax,
      @JsonKey(name: 'temperature_2m_min') List<double?> temperature2mMin});
}

/// @nodoc
class __$$DailyImplCopyWithImpl<$Res>
    extends _$DailyCopyWithImpl<$Res, _$DailyImpl>
    implements _$$DailyImplCopyWith<$Res> {
  __$$DailyImplCopyWithImpl(
      _$DailyImpl _value, $Res Function(_$DailyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? weatherCode = null,
    Object? temperature2mMax = null,
    Object? temperature2mMin = null,
  }) {
    return _then(_$DailyImpl(
      time: null == time
          ? _value._time
          : time // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weatherCode: null == weatherCode
          ? _value._weatherCode
          : weatherCode // ignore: cast_nullable_to_non_nullable
              as List<int?>,
      temperature2mMax: null == temperature2mMax
          ? _value._temperature2mMax
          : temperature2mMax // ignore: cast_nullable_to_non_nullable
              as List<double?>,
      temperature2mMin: null == temperature2mMin
          ? _value._temperature2mMin
          : temperature2mMin // ignore: cast_nullable_to_non_nullable
              as List<double?>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyImpl implements _Daily {
  const _$DailyImpl(
      {required final List<String> time,
      @JsonKey(name: 'weather_code') required final List<int?> weatherCode,
      @JsonKey(name: 'temperature_2m_max')
      required final List<double?> temperature2mMax,
      @JsonKey(name: 'temperature_2m_min')
      required final List<double?> temperature2mMin})
      : _time = time,
        _weatherCode = weatherCode,
        _temperature2mMax = temperature2mMax,
        _temperature2mMin = temperature2mMin;

  factory _$DailyImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyImplFromJson(json);

  final List<String> _time;
  @override
  List<String> get time {
    if (_time is EqualUnmodifiableListView) return _time;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_time);
  }

  final List<int?> _weatherCode;
  @override
  @JsonKey(name: 'weather_code')
  List<int?> get weatherCode {
    if (_weatherCode is EqualUnmodifiableListView) return _weatherCode;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weatherCode);
  }

  final List<double?> _temperature2mMax;
  @override
  @JsonKey(name: 'temperature_2m_max')
  List<double?> get temperature2mMax {
    if (_temperature2mMax is EqualUnmodifiableListView)
      return _temperature2mMax;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_temperature2mMax);
  }

  final List<double?> _temperature2mMin;
  @override
  @JsonKey(name: 'temperature_2m_min')
  List<double?> get temperature2mMin {
    if (_temperature2mMin is EqualUnmodifiableListView)
      return _temperature2mMin;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_temperature2mMin);
  }

  @override
  String toString() {
    return 'Daily(time: $time, weatherCode: $weatherCode, temperature2mMax: $temperature2mMax, temperature2mMin: $temperature2mMin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyImpl &&
            const DeepCollectionEquality().equals(other._time, _time) &&
            const DeepCollectionEquality()
                .equals(other._weatherCode, _weatherCode) &&
            const DeepCollectionEquality()
                .equals(other._temperature2mMax, _temperature2mMax) &&
            const DeepCollectionEquality()
                .equals(other._temperature2mMin, _temperature2mMin));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_time),
      const DeepCollectionEquality().hash(_weatherCode),
      const DeepCollectionEquality().hash(_temperature2mMax),
      const DeepCollectionEquality().hash(_temperature2mMin));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyImplCopyWith<_$DailyImpl> get copyWith =>
      __$$DailyImplCopyWithImpl<_$DailyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyImplToJson(
      this,
    );
  }
}

abstract class _Daily implements Daily {
  const factory _Daily(
      {required final List<String> time,
      @JsonKey(name: 'weather_code') required final List<int?> weatherCode,
      @JsonKey(name: 'temperature_2m_max')
      required final List<double?> temperature2mMax,
      @JsonKey(name: 'temperature_2m_min')
      required final List<double?> temperature2mMin}) = _$DailyImpl;

  factory _Daily.fromJson(Map<String, dynamic> json) = _$DailyImpl.fromJson;

  @override
  List<String> get time;
  @override
  @JsonKey(name: 'weather_code')
  List<int?> get weatherCode;
  @override
  @JsonKey(name: 'temperature_2m_max')
  List<double?> get temperature2mMax;
  @override
  @JsonKey(name: 'temperature_2m_min')
  List<double?> get temperature2mMin;
  @override
  @JsonKey(ignore: true)
  _$$DailyImplCopyWith<_$DailyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
