// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Position _$PositionFromJson(Map<String, dynamic> json) {
  return _Position.fromJson(json);
}

/// @nodoc
mixin _$Position {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get altitude => throw _privateConstructorUsedError;
  @JsonKey(name: "place_name")
  String? get placeName => throw _privateConstructorUsedError;
  @JsonKey(name: "place_type")
  String get placeType => throw _privateConstructorUsedError;
  @JsonKey(name: "city_name")
  String? get cityName => throw _privateConstructorUsedError;
  @JsonKey(name: "country_name")
  String? get countryName => throw _privateConstructorUsedError;
  @JsonKey(name: "county_name")
  String? get countyName => throw _privateConstructorUsedError;
  @JsonKey(name: "state_name")
  String? get stateName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PositionCopyWith<Position> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositionCopyWith<$Res> {
  factory $PositionCopyWith(Position value, $Res Function(Position) then) =
      _$PositionCopyWithImpl<$Res, Position>;
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      double? altitude,
      @JsonKey(name: "place_name") String? placeName,
      @JsonKey(name: "place_type") String placeType,
      @JsonKey(name: "city_name") String? cityName,
      @JsonKey(name: "country_name") String? countryName,
      @JsonKey(name: "county_name") String? countyName,
      @JsonKey(name: "state_name") String? stateName});
}

/// @nodoc
class _$PositionCopyWithImpl<$Res, $Val extends Position>
    implements $PositionCopyWith<$Res> {
  _$PositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? altitude = freezed,
    Object? placeName = freezed,
    Object? placeType = null,
    Object? cityName = freezed,
    Object? countryName = freezed,
    Object? countyName = freezed,
    Object? stateName = freezed,
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
      altitude: freezed == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double?,
      placeName: freezed == placeName
          ? _value.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String?,
      placeType: null == placeType
          ? _value.placeType
          : placeType // ignore: cast_nullable_to_non_nullable
              as String,
      cityName: freezed == cityName
          ? _value.cityName
          : cityName // ignore: cast_nullable_to_non_nullable
              as String?,
      countryName: freezed == countryName
          ? _value.countryName
          : countryName // ignore: cast_nullable_to_non_nullable
              as String?,
      countyName: freezed == countyName
          ? _value.countyName
          : countyName // ignore: cast_nullable_to_non_nullable
              as String?,
      stateName: freezed == stateName
          ? _value.stateName
          : stateName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PositionImplCopyWith<$Res>
    implements $PositionCopyWith<$Res> {
  factory _$$PositionImplCopyWith(
          _$PositionImpl value, $Res Function(_$PositionImpl) then) =
      __$$PositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double latitude,
      double longitude,
      double? altitude,
      @JsonKey(name: "place_name") String? placeName,
      @JsonKey(name: "place_type") String placeType,
      @JsonKey(name: "city_name") String? cityName,
      @JsonKey(name: "country_name") String? countryName,
      @JsonKey(name: "county_name") String? countyName,
      @JsonKey(name: "state_name") String? stateName});
}

/// @nodoc
class __$$PositionImplCopyWithImpl<$Res>
    extends _$PositionCopyWithImpl<$Res, _$PositionImpl>
    implements _$$PositionImplCopyWith<$Res> {
  __$$PositionImplCopyWithImpl(
      _$PositionImpl _value, $Res Function(_$PositionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? altitude = freezed,
    Object? placeName = freezed,
    Object? placeType = null,
    Object? cityName = freezed,
    Object? countryName = freezed,
    Object? countyName = freezed,
    Object? stateName = freezed,
  }) {
    return _then(_$PositionImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      altitude: freezed == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double?,
      placeName: freezed == placeName
          ? _value.placeName
          : placeName // ignore: cast_nullable_to_non_nullable
              as String?,
      placeType: null == placeType
          ? _value.placeType
          : placeType // ignore: cast_nullable_to_non_nullable
              as String,
      cityName: freezed == cityName
          ? _value.cityName
          : cityName // ignore: cast_nullable_to_non_nullable
              as String?,
      countryName: freezed == countryName
          ? _value.countryName
          : countryName // ignore: cast_nullable_to_non_nullable
              as String?,
      countyName: freezed == countyName
          ? _value.countyName
          : countyName // ignore: cast_nullable_to_non_nullable
              as String?,
      stateName: freezed == stateName
          ? _value.stateName
          : stateName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PositionImpl extends _Position {
  const _$PositionImpl(
      {required this.latitude,
      required this.longitude,
      required this.altitude,
      @JsonKey(name: "place_name") required this.placeName,
      @JsonKey(name: "place_type") required this.placeType,
      @JsonKey(name: "city_name") required this.cityName,
      @JsonKey(name: "country_name") required this.countryName,
      @JsonKey(name: "county_name") required this.countyName,
      @JsonKey(name: "state_name") required this.stateName})
      : super._();

  factory _$PositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PositionImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? altitude;
  @override
  @JsonKey(name: "place_name")
  final String? placeName;
  @override
  @JsonKey(name: "place_type")
  final String placeType;
  @override
  @JsonKey(name: "city_name")
  final String? cityName;
  @override
  @JsonKey(name: "country_name")
  final String? countryName;
  @override
  @JsonKey(name: "county_name")
  final String? countyName;
  @override
  @JsonKey(name: "state_name")
  final String? stateName;

  @override
  String toString() {
    return 'Position(latitude: $latitude, longitude: $longitude, altitude: $altitude, placeName: $placeName, placeType: $placeType, cityName: $cityName, countryName: $countryName, countyName: $countyName, stateName: $stateName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositionImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.placeName, placeName) ||
                other.placeName == placeName) &&
            (identical(other.placeType, placeType) ||
                other.placeType == placeType) &&
            (identical(other.cityName, cityName) ||
                other.cityName == cityName) &&
            (identical(other.countryName, countryName) ||
                other.countryName == countryName) &&
            (identical(other.countyName, countyName) ||
                other.countyName == countyName) &&
            (identical(other.stateName, stateName) ||
                other.stateName == stateName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude, altitude,
      placeName, placeType, cityName, countryName, countyName, stateName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PositionImplCopyWith<_$PositionImpl> get copyWith =>
      __$$PositionImplCopyWithImpl<_$PositionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PositionImplToJson(
      this,
    );
  }
}

abstract class _Position extends Position {
  const factory _Position(
          {required final double latitude,
          required final double longitude,
          required final double? altitude,
          @JsonKey(name: "place_name") required final String? placeName,
          @JsonKey(name: "place_type") required final String placeType,
          @JsonKey(name: "city_name") required final String? cityName,
          @JsonKey(name: "country_name") required final String? countryName,
          @JsonKey(name: "county_name") required final String? countyName,
          @JsonKey(name: "state_name") required final String? stateName}) =
      _$PositionImpl;
  const _Position._() : super._();

  factory _Position.fromJson(Map<String, dynamic> json) =
      _$PositionImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get altitude;
  @override
  @JsonKey(name: "place_name")
  String? get placeName;
  @override
  @JsonKey(name: "place_type")
  String get placeType;
  @override
  @JsonKey(name: "city_name")
  String? get cityName;
  @override
  @JsonKey(name: "country_name")
  String? get countryName;
  @override
  @JsonKey(name: "county_name")
  String? get countyName;
  @override
  @JsonKey(name: "state_name")
  String? get stateName;
  @override
  @JsonKey(ignore: true)
  _$$PositionImplCopyWith<_$PositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
