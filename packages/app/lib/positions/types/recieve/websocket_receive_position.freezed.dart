// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_receive_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketReceivePosition _$WebsocketReceivePositionFromJson(
    Map<String, dynamic> json) {
  return _WebsocketReceivePosition.fromJson(json);
}

/// @nodoc
mixin _$WebsocketReceivePosition {
  String get type => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get altitude => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;
  double get speed => throw _privateConstructorUsedError;
  @JsonKey(name: "user")
  int get userId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketReceivePositionCopyWith<WebsocketReceivePosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketReceivePositionCopyWith<$Res> {
  factory $WebsocketReceivePositionCopyWith(WebsocketReceivePosition value,
          $Res Function(WebsocketReceivePosition) then) =
      _$WebsocketReceivePositionCopyWithImpl<$Res, WebsocketReceivePosition>;
  @useResult
  $Res call(
      {String type,
      double latitude,
      double longitude,
      double altitude,
      DateTime time,
      double speed,
      @JsonKey(name: "user") int userId});
}

/// @nodoc
class _$WebsocketReceivePositionCopyWithImpl<$Res,
        $Val extends WebsocketReceivePosition>
    implements $WebsocketReceivePositionCopyWith<$Res> {
  _$WebsocketReceivePositionCopyWithImpl(this._value, this._then);

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
    Object? speed = null,
    Object? userId = null,
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
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketReceivePositionImplCopyWith<$Res>
    implements $WebsocketReceivePositionCopyWith<$Res> {
  factory _$$WebsocketReceivePositionImplCopyWith(
          _$WebsocketReceivePositionImpl value,
          $Res Function(_$WebsocketReceivePositionImpl) then) =
      __$$WebsocketReceivePositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      double latitude,
      double longitude,
      double altitude,
      DateTime time,
      double speed,
      @JsonKey(name: "user") int userId});
}

/// @nodoc
class __$$WebsocketReceivePositionImplCopyWithImpl<$Res>
    extends _$WebsocketReceivePositionCopyWithImpl<$Res,
        _$WebsocketReceivePositionImpl>
    implements _$$WebsocketReceivePositionImplCopyWith<$Res> {
  __$$WebsocketReceivePositionImplCopyWithImpl(
      _$WebsocketReceivePositionImpl _value,
      $Res Function(_$WebsocketReceivePositionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? altitude = null,
    Object? time = null,
    Object? speed = null,
    Object? userId = null,
  }) {
    return _then(_$WebsocketReceivePositionImpl(
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
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebsocketReceivePositionImpl implements _WebsocketReceivePosition {
  const _$WebsocketReceivePositionImpl(
      {required this.type,
      required this.latitude,
      required this.longitude,
      required this.altitude,
      required this.time,
      required this.speed,
      @JsonKey(name: "user") required this.userId});

  factory _$WebsocketReceivePositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebsocketReceivePositionImplFromJson(json);

  @override
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
  final double speed;
  @override
  @JsonKey(name: "user")
  final int userId;

  @override
  String toString() {
    return 'WebsocketReceivePosition(type: $type, latitude: $latitude, longitude: $longitude, altitude: $altitude, time: $time, speed: $speed, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketReceivePositionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, latitude, longitude, altitude, time, speed, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketReceivePositionImplCopyWith<_$WebsocketReceivePositionImpl>
      get copyWith => __$$WebsocketReceivePositionImplCopyWithImpl<
          _$WebsocketReceivePositionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketReceivePositionImplToJson(
      this,
    );
  }
}

abstract class _WebsocketReceivePosition implements WebsocketReceivePosition {
  const factory _WebsocketReceivePosition(
          {required final String type,
          required final double latitude,
          required final double longitude,
          required final double altitude,
          required final DateTime time,
          required final double speed,
          @JsonKey(name: "user") required final int userId}) =
      _$WebsocketReceivePositionImpl;

  factory _WebsocketReceivePosition.fromJson(Map<String, dynamic> json) =
      _$WebsocketReceivePositionImpl.fromJson;

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
  double get speed;
  @override
  @JsonKey(name: "user")
  int get userId;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketReceivePositionImplCopyWith<_$WebsocketReceivePositionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
