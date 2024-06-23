// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketPosition _$WebsocketPositionFromJson(Map<String, dynamic> json) {
  return _WebsocketPosition.fromJson(json);
}

/// @nodoc
mixin _$WebsocketPosition {
  String get type => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get altitude => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketPositionCopyWith<WebsocketPosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketPositionCopyWith<$Res> {
  factory $WebsocketPositionCopyWith(
          WebsocketPosition value, $Res Function(WebsocketPosition) then) =
      _$WebsocketPositionCopyWithImpl<$Res, WebsocketPosition>;
  @useResult
  $Res call(
      {String type,
      double latitude,
      double longitude,
      double altitude,
      DateTime time});
}

/// @nodoc
class _$WebsocketPositionCopyWithImpl<$Res, $Val extends WebsocketPosition>
    implements $WebsocketPositionCopyWith<$Res> {
  _$WebsocketPositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? altitude = null,
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      altitude: null == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketPositionImplCopyWith<$Res>
    implements $WebsocketPositionCopyWith<$Res> {
  factory _$$WebsocketPositionImplCopyWith(_$WebsocketPositionImpl value,
          $Res Function(_$WebsocketPositionImpl) then) =
      __$$WebsocketPositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      double latitude,
      double longitude,
      double altitude,
      DateTime time});
}

/// @nodoc
class __$$WebsocketPositionImplCopyWithImpl<$Res>
    extends _$WebsocketPositionCopyWithImpl<$Res, _$WebsocketPositionImpl>
    implements _$$WebsocketPositionImplCopyWith<$Res> {
  __$$WebsocketPositionImplCopyWithImpl(_$WebsocketPositionImpl _value,
      $Res Function(_$WebsocketPositionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? altitude = null,
    Object? time = null,
  }) {
    return _then(_$WebsocketPositionImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      altitude: null == altitude
          ? _value.altitude
          : altitude // ignore: cast_nullable_to_non_nullable
              as double,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebsocketPositionImpl implements _WebsocketPosition {
  const _$WebsocketPositionImpl(
      {this.type = "send-user-position",
      required this.latitude,
      required this.longitude,
      required this.altitude,
      required this.time});

  factory _$WebsocketPositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebsocketPositionImplFromJson(json);

  @override
  @JsonKey()
  final String type;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double altitude;
  @override
  final DateTime time;

  @override
  String toString() {
    return 'WebsocketPosition(type: $type, latitude: $latitude, longitude: $longitude, altitude: $altitude, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketPositionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, latitude, longitude, altitude, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketPositionImplCopyWith<_$WebsocketPositionImpl> get copyWith =>
      __$$WebsocketPositionImplCopyWithImpl<_$WebsocketPositionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketPositionImplToJson(
      this,
    );
  }
}

abstract class _WebsocketPosition implements WebsocketPosition {
  const factory _WebsocketPosition(
      {final String type,
      required final double latitude,
      required final double longitude,
      required final double altitude,
      required final DateTime time}) = _$WebsocketPositionImpl;

  factory _WebsocketPosition.fromJson(Map<String, dynamic> json) =
      _$WebsocketPositionImpl.fromJson;

  @override
  String get type;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get altitude;
  @override
  DateTime get time;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketPositionImplCopyWith<_$WebsocketPositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
