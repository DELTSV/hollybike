/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_send_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketSendPosition _$WebsocketSendPositionFromJson(
    Map<String, dynamic> json) {
  return _WebsocketSendPosition.fromJson(json);
}

/// @nodoc
mixin _$WebsocketSendPosition {
  String get type => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get altitude => throw _privateConstructorUsedError;
  double get heading => throw _privateConstructorUsedError;
  @JsonKey(name: "acceleration_x")
  double get accelerationX => throw _privateConstructorUsedError;
  @JsonKey(name: "acceleration_y")
  double get accelerationY => throw _privateConstructorUsedError;
  @JsonKey(name: "acceleration_z")
  double get accelerationZ => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;
  double get speed => throw _privateConstructorUsedError;
  @JsonKey(name: "speed_accuracy")
  double get speedAccuracy => throw _privateConstructorUsedError;
  double get accuracy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketSendPositionCopyWith<WebsocketSendPosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketSendPositionCopyWith<$Res> {
  factory $WebsocketSendPositionCopyWith(WebsocketSendPosition value,
          $Res Function(WebsocketSendPosition) then) =
      _$WebsocketSendPositionCopyWithImpl<$Res, WebsocketSendPosition>;
  @useResult
  $Res call(
      {String type,
      double latitude,
      double longitude,
      double altitude,
      double heading,
      @JsonKey(name: "acceleration_x") double accelerationX,
      @JsonKey(name: "acceleration_y") double accelerationY,
      @JsonKey(name: "acceleration_z") double accelerationZ,
      DateTime time,
      double speed,
      @JsonKey(name: "speed_accuracy") double speedAccuracy,
      double accuracy});
}

/// @nodoc
class _$WebsocketSendPositionCopyWithImpl<$Res,
        $Val extends WebsocketSendPosition>
    implements $WebsocketSendPositionCopyWith<$Res> {
  _$WebsocketSendPositionCopyWithImpl(this._value, this._then);

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
    Object? heading = null,
    Object? accelerationX = null,
    Object? accelerationY = null,
    Object? accelerationZ = null,
    Object? time = null,
    Object? speed = null,
    Object? speedAccuracy = null,
    Object? accuracy = null,
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
      heading: null == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double,
      accelerationX: null == accelerationX
          ? _value.accelerationX
          : accelerationX // ignore: cast_nullable_to_non_nullable
              as double,
      accelerationY: null == accelerationY
          ? _value.accelerationY
          : accelerationY // ignore: cast_nullable_to_non_nullable
              as double,
      accelerationZ: null == accelerationZ
          ? _value.accelerationZ
          : accelerationZ // ignore: cast_nullable_to_non_nullable
              as double,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      speedAccuracy: null == speedAccuracy
          ? _value.speedAccuracy
          : speedAccuracy // ignore: cast_nullable_to_non_nullable
              as double,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketSendPositionImplCopyWith<$Res>
    implements $WebsocketSendPositionCopyWith<$Res> {
  factory _$$WebsocketSendPositionImplCopyWith(
          _$WebsocketSendPositionImpl value,
          $Res Function(_$WebsocketSendPositionImpl) then) =
      __$$WebsocketSendPositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      double latitude,
      double longitude,
      double altitude,
      double heading,
      @JsonKey(name: "acceleration_x") double accelerationX,
      @JsonKey(name: "acceleration_y") double accelerationY,
      @JsonKey(name: "acceleration_z") double accelerationZ,
      DateTime time,
      double speed,
      @JsonKey(name: "speed_accuracy") double speedAccuracy,
      double accuracy});
}

/// @nodoc
class __$$WebsocketSendPositionImplCopyWithImpl<$Res>
    extends _$WebsocketSendPositionCopyWithImpl<$Res,
        _$WebsocketSendPositionImpl>
    implements _$$WebsocketSendPositionImplCopyWith<$Res> {
  __$$WebsocketSendPositionImplCopyWithImpl(_$WebsocketSendPositionImpl _value,
      $Res Function(_$WebsocketSendPositionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? altitude = null,
    Object? heading = null,
    Object? accelerationX = null,
    Object? accelerationY = null,
    Object? accelerationZ = null,
    Object? time = null,
    Object? speed = null,
    Object? speedAccuracy = null,
    Object? accuracy = null,
  }) {
    return _then(_$WebsocketSendPositionImpl(
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
      heading: null == heading
          ? _value.heading
          : heading // ignore: cast_nullable_to_non_nullable
              as double,
      accelerationX: null == accelerationX
          ? _value.accelerationX
          : accelerationX // ignore: cast_nullable_to_non_nullable
              as double,
      accelerationY: null == accelerationY
          ? _value.accelerationY
          : accelerationY // ignore: cast_nullable_to_non_nullable
              as double,
      accelerationZ: null == accelerationZ
          ? _value.accelerationZ
          : accelerationZ // ignore: cast_nullable_to_non_nullable
              as double,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      speedAccuracy: null == speedAccuracy
          ? _value.speedAccuracy
          : speedAccuracy // ignore: cast_nullable_to_non_nullable
              as double,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebsocketSendPositionImpl implements _WebsocketSendPosition {
  const _$WebsocketSendPositionImpl(
      {this.type = "send-user-position",
      required this.latitude,
      required this.longitude,
      required this.altitude,
      required this.heading,
      @JsonKey(name: "acceleration_x") required this.accelerationX,
      @JsonKey(name: "acceleration_y") required this.accelerationY,
      @JsonKey(name: "acceleration_z") required this.accelerationZ,
      required this.time,
      required this.speed,
      @JsonKey(name: "speed_accuracy") required this.speedAccuracy,
      required this.accuracy});

  factory _$WebsocketSendPositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebsocketSendPositionImplFromJson(json);

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
  final double heading;
  @override
  @JsonKey(name: "acceleration_x")
  final double accelerationX;
  @override
  @JsonKey(name: "acceleration_y")
  final double accelerationY;
  @override
  @JsonKey(name: "acceleration_z")
  final double accelerationZ;
  @override
  final DateTime time;
  @override
  final double speed;
  @override
  @JsonKey(name: "speed_accuracy")
  final double speedAccuracy;
  @override
  final double accuracy;

  @override
  String toString() {
    return 'WebsocketSendPosition(type: $type, latitude: $latitude, longitude: $longitude, altitude: $altitude, heading: $heading, accelerationX: $accelerationX, accelerationY: $accelerationY, accelerationZ: $accelerationZ, time: $time, speed: $speed, speedAccuracy: $speedAccuracy, accuracy: $accuracy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketSendPositionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.accelerationX, accelerationX) ||
                other.accelerationX == accelerationX) &&
            (identical(other.accelerationY, accelerationY) ||
                other.accelerationY == accelerationY) &&
            (identical(other.accelerationZ, accelerationZ) ||
                other.accelerationZ == accelerationZ) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.speedAccuracy, speedAccuracy) ||
                other.speedAccuracy == speedAccuracy) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      latitude,
      longitude,
      altitude,
      heading,
      accelerationX,
      accelerationY,
      accelerationZ,
      time,
      speed,
      speedAccuracy,
      accuracy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketSendPositionImplCopyWith<_$WebsocketSendPositionImpl>
      get copyWith => __$$WebsocketSendPositionImplCopyWithImpl<
          _$WebsocketSendPositionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketSendPositionImplToJson(
      this,
    );
  }
}

abstract class _WebsocketSendPosition implements WebsocketSendPosition {
  const factory _WebsocketSendPosition(
      {final String type,
      required final double latitude,
      required final double longitude,
      required final double altitude,
      required final double heading,
      @JsonKey(name: "acceleration_x") required final double accelerationX,
      @JsonKey(name: "acceleration_y") required final double accelerationY,
      @JsonKey(name: "acceleration_z") required final double accelerationZ,
      required final DateTime time,
      required final double speed,
      @JsonKey(name: "speed_accuracy") required final double speedAccuracy,
      required final double accuracy}) = _$WebsocketSendPositionImpl;

  factory _WebsocketSendPosition.fromJson(Map<String, dynamic> json) =
      _$WebsocketSendPositionImpl.fromJson;

  @override
  String get type;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get altitude;
  @override
  double get heading;
  @override
  @JsonKey(name: "acceleration_x")
  double get accelerationX;
  @override
  @JsonKey(name: "acceleration_y")
  double get accelerationY;
  @override
  @JsonKey(name: "acceleration_z")
  double get accelerationZ;
  @override
  DateTime get time;
  @override
  double get speed;
  @override
  @JsonKey(name: "speed_accuracy")
  double get speedAccuracy;
  @override
  double get accuracy;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketSendPositionImplCopyWith<_$WebsocketSendPositionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
