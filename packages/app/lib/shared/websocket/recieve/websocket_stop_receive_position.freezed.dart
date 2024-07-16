/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_stop_receive_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketStopReceivePosition _$WebsocketStopReceivePositionFromJson(
    Map<String, dynamic> json) {
  return _WebsocketStopReceivePosition.fromJson(json);
}

/// @nodoc
mixin _$WebsocketStopReceivePosition {
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: "user")
  int get userId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketStopReceivePositionCopyWith<WebsocketStopReceivePosition>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketStopReceivePositionCopyWith<$Res> {
  factory $WebsocketStopReceivePositionCopyWith(
          WebsocketStopReceivePosition value,
          $Res Function(WebsocketStopReceivePosition) then) =
      _$WebsocketStopReceivePositionCopyWithImpl<$Res,
          WebsocketStopReceivePosition>;
  @useResult
  $Res call({String type, @JsonKey(name: "user") int userId});
}

/// @nodoc
class _$WebsocketStopReceivePositionCopyWithImpl<$Res,
        $Val extends WebsocketStopReceivePosition>
    implements $WebsocketStopReceivePositionCopyWith<$Res> {
  _$WebsocketStopReceivePositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketStopReceivePositionImplCopyWith<$Res>
    implements $WebsocketStopReceivePositionCopyWith<$Res> {
  factory _$$WebsocketStopReceivePositionImplCopyWith(
          _$WebsocketStopReceivePositionImpl value,
          $Res Function(_$WebsocketStopReceivePositionImpl) then) =
      __$$WebsocketStopReceivePositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, @JsonKey(name: "user") int userId});
}

/// @nodoc
class __$$WebsocketStopReceivePositionImplCopyWithImpl<$Res>
    extends _$WebsocketStopReceivePositionCopyWithImpl<$Res,
        _$WebsocketStopReceivePositionImpl>
    implements _$$WebsocketStopReceivePositionImplCopyWith<$Res> {
  __$$WebsocketStopReceivePositionImplCopyWithImpl(
      _$WebsocketStopReceivePositionImpl _value,
      $Res Function(_$WebsocketStopReceivePositionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? userId = null,
  }) {
    return _then(_$WebsocketStopReceivePositionImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebsocketStopReceivePositionImpl
    implements _WebsocketStopReceivePosition {
  const _$WebsocketStopReceivePositionImpl(
      {required this.type, @JsonKey(name: "user") required this.userId});

  factory _$WebsocketStopReceivePositionImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$WebsocketStopReceivePositionImplFromJson(json);

  @override
  final String type;
  @override
  @JsonKey(name: "user")
  final int userId;

  @override
  String toString() {
    return 'WebsocketStopReceivePosition(type: $type, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketStopReceivePositionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketStopReceivePositionImplCopyWith<
          _$WebsocketStopReceivePositionImpl>
      get copyWith => __$$WebsocketStopReceivePositionImplCopyWithImpl<
          _$WebsocketStopReceivePositionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketStopReceivePositionImplToJson(
      this,
    );
  }
}

abstract class _WebsocketStopReceivePosition
    implements WebsocketStopReceivePosition {
  const factory _WebsocketStopReceivePosition(
          {required final String type,
          @JsonKey(name: "user") required final int userId}) =
      _$WebsocketStopReceivePositionImpl;

  factory _WebsocketStopReceivePosition.fromJson(Map<String, dynamic> json) =
      _$WebsocketStopReceivePositionImpl.fromJson;

  @override
  String get type;
  @override
  @JsonKey(name: "user")
  int get userId;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketStopReceivePositionImplCopyWith<
          _$WebsocketStopReceivePositionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
