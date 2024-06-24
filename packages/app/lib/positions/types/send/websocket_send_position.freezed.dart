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
  DateTime get time => throw _privateConstructorUsedError;

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
      DateTime time});
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
      DateTime time});
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
    Object? time = null,
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
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
      required this.time});

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
  final DateTime time;

  @override
  String toString() {
    return 'WebsocketSendPosition(type: $type, latitude: $latitude, longitude: $longitude, altitude: $altitude, time: $time)';
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
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, latitude, longitude, altitude, time);

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
      required final DateTime time}) = _$WebsocketSendPositionImpl;

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
  DateTime get time;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketSendPositionImplCopyWith<_$WebsocketSendPositionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
