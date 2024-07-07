// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_forecast_grouped.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WeatherForecastGrouped {
  List<DailyWeatherGrouped> get dailyWeather =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WeatherForecastGroupedCopyWith<WeatherForecastGrouped> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherForecastGroupedCopyWith<$Res> {
  factory $WeatherForecastGroupedCopyWith(WeatherForecastGrouped value,
          $Res Function(WeatherForecastGrouped) then) =
      _$WeatherForecastGroupedCopyWithImpl<$Res, WeatherForecastGrouped>;
  @useResult
  $Res call({List<DailyWeatherGrouped> dailyWeather});
}

/// @nodoc
class _$WeatherForecastGroupedCopyWithImpl<$Res,
        $Val extends WeatherForecastGrouped>
    implements $WeatherForecastGroupedCopyWith<$Res> {
  _$WeatherForecastGroupedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyWeather = null,
  }) {
    return _then(_value.copyWith(
      dailyWeather: null == dailyWeather
          ? _value.dailyWeather
          : dailyWeather // ignore: cast_nullable_to_non_nullable
              as List<DailyWeatherGrouped>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeatherForecastGroupedImplCopyWith<$Res>
    implements $WeatherForecastGroupedCopyWith<$Res> {
  factory _$$WeatherForecastGroupedImplCopyWith(
          _$WeatherForecastGroupedImpl value,
          $Res Function(_$WeatherForecastGroupedImpl) then) =
      __$$WeatherForecastGroupedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DailyWeatherGrouped> dailyWeather});
}

/// @nodoc
class __$$WeatherForecastGroupedImplCopyWithImpl<$Res>
    extends _$WeatherForecastGroupedCopyWithImpl<$Res,
        _$WeatherForecastGroupedImpl>
    implements _$$WeatherForecastGroupedImplCopyWith<$Res> {
  __$$WeatherForecastGroupedImplCopyWithImpl(
      _$WeatherForecastGroupedImpl _value,
      $Res Function(_$WeatherForecastGroupedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyWeather = null,
  }) {
    return _then(_$WeatherForecastGroupedImpl(
      dailyWeather: null == dailyWeather
          ? _value._dailyWeather
          : dailyWeather // ignore: cast_nullable_to_non_nullable
              as List<DailyWeatherGrouped>,
    ));
  }
}

/// @nodoc

class _$WeatherForecastGroupedImpl implements _WeatherForecastGrouped {
  const _$WeatherForecastGroupedImpl(
      {required final List<DailyWeatherGrouped> dailyWeather})
      : _dailyWeather = dailyWeather;

  final List<DailyWeatherGrouped> _dailyWeather;
  @override
  List<DailyWeatherGrouped> get dailyWeather {
    if (_dailyWeather is EqualUnmodifiableListView) return _dailyWeather;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyWeather);
  }

  @override
  String toString() {
    return 'WeatherForecastGrouped(dailyWeather: $dailyWeather)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeatherForecastGroupedImpl &&
            const DeepCollectionEquality()
                .equals(other._dailyWeather, _dailyWeather));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_dailyWeather));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeatherForecastGroupedImplCopyWith<_$WeatherForecastGroupedImpl>
      get copyWith => __$$WeatherForecastGroupedImplCopyWithImpl<
          _$WeatherForecastGroupedImpl>(this, _$identity);
}

abstract class _WeatherForecastGrouped implements WeatherForecastGrouped {
  const factory _WeatherForecastGrouped(
          {required final List<DailyWeatherGrouped> dailyWeather}) =
      _$WeatherForecastGroupedImpl;

  @override
  List<DailyWeatherGrouped> get dailyWeather;
  @override
  @JsonKey(ignore: true)
  _$$WeatherForecastGroupedImplCopyWith<_$WeatherForecastGroupedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DailyWeatherGrouped {
  String get date => throw _privateConstructorUsedError;
  String get maxTemperature => throw _privateConstructorUsedError;
  String get minTemperature => throw _privateConstructorUsedError;
  int get weatherCode => throw _privateConstructorUsedError;
  List<HourlyWeather> get hourlyWeather => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DailyWeatherGroupedCopyWith<DailyWeatherGrouped> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyWeatherGroupedCopyWith<$Res> {
  factory $DailyWeatherGroupedCopyWith(
          DailyWeatherGrouped value, $Res Function(DailyWeatherGrouped) then) =
      _$DailyWeatherGroupedCopyWithImpl<$Res, DailyWeatherGrouped>;
  @useResult
  $Res call(
      {String date,
      String maxTemperature,
      String minTemperature,
      int weatherCode,
      List<HourlyWeather> hourlyWeather});
}

/// @nodoc
class _$DailyWeatherGroupedCopyWithImpl<$Res, $Val extends DailyWeatherGrouped>
    implements $DailyWeatherGroupedCopyWith<$Res> {
  _$DailyWeatherGroupedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? maxTemperature = null,
    Object? minTemperature = null,
    Object? weatherCode = null,
    Object? hourlyWeather = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      maxTemperature: null == maxTemperature
          ? _value.maxTemperature
          : maxTemperature // ignore: cast_nullable_to_non_nullable
              as String,
      minTemperature: null == minTemperature
          ? _value.minTemperature
          : minTemperature // ignore: cast_nullable_to_non_nullable
              as String,
      weatherCode: null == weatherCode
          ? _value.weatherCode
          : weatherCode // ignore: cast_nullable_to_non_nullable
              as int,
      hourlyWeather: null == hourlyWeather
          ? _value.hourlyWeather
          : hourlyWeather // ignore: cast_nullable_to_non_nullable
              as List<HourlyWeather>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyWeatherGroupedImplCopyWith<$Res>
    implements $DailyWeatherGroupedCopyWith<$Res> {
  factory _$$DailyWeatherGroupedImplCopyWith(_$DailyWeatherGroupedImpl value,
          $Res Function(_$DailyWeatherGroupedImpl) then) =
      __$$DailyWeatherGroupedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      String maxTemperature,
      String minTemperature,
      int weatherCode,
      List<HourlyWeather> hourlyWeather});
}

/// @nodoc
class __$$DailyWeatherGroupedImplCopyWithImpl<$Res>
    extends _$DailyWeatherGroupedCopyWithImpl<$Res, _$DailyWeatherGroupedImpl>
    implements _$$DailyWeatherGroupedImplCopyWith<$Res> {
  __$$DailyWeatherGroupedImplCopyWithImpl(_$DailyWeatherGroupedImpl _value,
      $Res Function(_$DailyWeatherGroupedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? maxTemperature = null,
    Object? minTemperature = null,
    Object? weatherCode = null,
    Object? hourlyWeather = null,
  }) {
    return _then(_$DailyWeatherGroupedImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      maxTemperature: null == maxTemperature
          ? _value.maxTemperature
          : maxTemperature // ignore: cast_nullable_to_non_nullable
              as String,
      minTemperature: null == minTemperature
          ? _value.minTemperature
          : minTemperature // ignore: cast_nullable_to_non_nullable
              as String,
      weatherCode: null == weatherCode
          ? _value.weatherCode
          : weatherCode // ignore: cast_nullable_to_non_nullable
              as int,
      hourlyWeather: null == hourlyWeather
          ? _value._hourlyWeather
          : hourlyWeather // ignore: cast_nullable_to_non_nullable
              as List<HourlyWeather>,
    ));
  }
}

/// @nodoc

class _$DailyWeatherGroupedImpl implements _DailyWeatherGrouped {
  const _$DailyWeatherGroupedImpl(
      {required this.date,
      required this.maxTemperature,
      required this.minTemperature,
      required this.weatherCode,
      required final List<HourlyWeather> hourlyWeather})
      : _hourlyWeather = hourlyWeather;

  @override
  final String date;
  @override
  final String maxTemperature;
  @override
  final String minTemperature;
  @override
  final int weatherCode;
  final List<HourlyWeather> _hourlyWeather;
  @override
  List<HourlyWeather> get hourlyWeather {
    if (_hourlyWeather is EqualUnmodifiableListView) return _hourlyWeather;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hourlyWeather);
  }

  @override
  String toString() {
    return 'DailyWeatherGrouped(date: $date, maxTemperature: $maxTemperature, minTemperature: $minTemperature, weatherCode: $weatherCode, hourlyWeather: $hourlyWeather)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyWeatherGroupedImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.maxTemperature, maxTemperature) ||
                other.maxTemperature == maxTemperature) &&
            (identical(other.minTemperature, minTemperature) ||
                other.minTemperature == minTemperature) &&
            (identical(other.weatherCode, weatherCode) ||
                other.weatherCode == weatherCode) &&
            const DeepCollectionEquality()
                .equals(other._hourlyWeather, _hourlyWeather));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      maxTemperature,
      minTemperature,
      weatherCode,
      const DeepCollectionEquality().hash(_hourlyWeather));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyWeatherGroupedImplCopyWith<_$DailyWeatherGroupedImpl> get copyWith =>
      __$$DailyWeatherGroupedImplCopyWithImpl<_$DailyWeatherGroupedImpl>(
          this, _$identity);
}

abstract class _DailyWeatherGrouped implements DailyWeatherGrouped {
  const factory _DailyWeatherGrouped(
          {required final String date,
          required final String maxTemperature,
          required final String minTemperature,
          required final int weatherCode,
          required final List<HourlyWeather> hourlyWeather}) =
      _$DailyWeatherGroupedImpl;

  @override
  String get date;
  @override
  String get maxTemperature;
  @override
  String get minTemperature;
  @override
  int get weatherCode;
  @override
  List<HourlyWeather> get hourlyWeather;
  @override
  @JsonKey(ignore: true)
  _$$DailyWeatherGroupedImplCopyWith<_$DailyWeatherGroupedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HourlyWeather {
  String get time => throw _privateConstructorUsedError;
  String? get temperature => throw _privateConstructorUsedError;
  int? get weatherCode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HourlyWeatherCopyWith<HourlyWeather> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HourlyWeatherCopyWith<$Res> {
  factory $HourlyWeatherCopyWith(
          HourlyWeather value, $Res Function(HourlyWeather) then) =
      _$HourlyWeatherCopyWithImpl<$Res, HourlyWeather>;
  @useResult
  $Res call({String time, String? temperature, int? weatherCode});
}

/// @nodoc
class _$HourlyWeatherCopyWithImpl<$Res, $Val extends HourlyWeather>
    implements $HourlyWeatherCopyWith<$Res> {
  _$HourlyWeatherCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? temperature = freezed,
    Object? weatherCode = freezed,
  }) {
    return _then(_value.copyWith(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: freezed == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as String?,
      weatherCode: freezed == weatherCode
          ? _value.weatherCode
          : weatherCode // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HourlyWeatherImplCopyWith<$Res>
    implements $HourlyWeatherCopyWith<$Res> {
  factory _$$HourlyWeatherImplCopyWith(
          _$HourlyWeatherImpl value, $Res Function(_$HourlyWeatherImpl) then) =
      __$$HourlyWeatherImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String time, String? temperature, int? weatherCode});
}

/// @nodoc
class __$$HourlyWeatherImplCopyWithImpl<$Res>
    extends _$HourlyWeatherCopyWithImpl<$Res, _$HourlyWeatherImpl>
    implements _$$HourlyWeatherImplCopyWith<$Res> {
  __$$HourlyWeatherImplCopyWithImpl(
      _$HourlyWeatherImpl _value, $Res Function(_$HourlyWeatherImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? temperature = freezed,
    Object? weatherCode = freezed,
  }) {
    return _then(_$HourlyWeatherImpl(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: freezed == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as String?,
      weatherCode: freezed == weatherCode
          ? _value.weatherCode
          : weatherCode // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$HourlyWeatherImpl implements _HourlyWeather {
  const _$HourlyWeatherImpl(
      {required this.time,
      required this.temperature,
      required this.weatherCode});

  @override
  final String time;
  @override
  final String? temperature;
  @override
  final int? weatherCode;

  @override
  String toString() {
    return 'HourlyWeather(time: $time, temperature: $temperature, weatherCode: $weatherCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HourlyWeatherImpl &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.weatherCode, weatherCode) ||
                other.weatherCode == weatherCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, time, temperature, weatherCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HourlyWeatherImplCopyWith<_$HourlyWeatherImpl> get copyWith =>
      __$$HourlyWeatherImplCopyWithImpl<_$HourlyWeatherImpl>(this, _$identity);
}

abstract class _HourlyWeather implements HourlyWeather {
  const factory _HourlyWeather(
      {required final String time,
      required final String? temperature,
      required final int? weatherCode}) = _$HourlyWeatherImpl;

  @override
  String get time;
  @override
  String? get temperature;
  @override
  int? get weatherCode;
  @override
  @JsonKey(ignore: true)
  _$$HourlyWeatherImplCopyWith<_$HourlyWeatherImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
