/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_stop_send_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketStopSendPosition _$WebsocketStopSendPositionFromJson(
    Map<String, dynamic> json) {
  return _WebsocketStopSendPosition.fromJson(json);
}

/// @nodoc
mixin _$WebsocketStopSendPosition {
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketStopSendPositionCopyWith<WebsocketStopSendPosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketStopSendPositionCopyWith<$Res> {
  factory $WebsocketStopSendPositionCopyWith(WebsocketStopSendPosition value,
          $Res Function(WebsocketStopSendPosition) then) =
      _$WebsocketStopSendPositionCopyWithImpl<$Res, WebsocketStopSendPosition>;
  @useResult
  $Res call({String type});
}

/// @nodoc
class _$WebsocketStopSendPositionCopyWithImpl<$Res,
        $Val extends WebsocketStopSendPosition>
    implements $WebsocketStopSendPositionCopyWith<$Res> {
  _$WebsocketStopSendPositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketStopSendPositionImplCopyWith<$Res>
    implements $WebsocketStopSendPositionCopyWith<$Res> {
  factory _$$WebsocketStopSendPositionImplCopyWith(
          _$WebsocketStopSendPositionImpl value,
          $Res Function(_$WebsocketStopSendPositionImpl) then) =
      __$$WebsocketStopSendPositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type});
}

/// @nodoc
class __$$WebsocketStopSendPositionImplCopyWithImpl<$Res>
    extends _$WebsocketStopSendPositionCopyWithImpl<$Res,
        _$WebsocketStopSendPositionImpl>
    implements _$$WebsocketStopSendPositionImplCopyWith<$Res> {
  __$$WebsocketStopSendPositionImplCopyWithImpl(
      _$WebsocketStopSendPositionImpl _value,
      $Res Function(_$WebsocketStopSendPositionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
  }) {
    return _then(_$WebsocketStopSendPositionImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebsocketStopSendPositionImpl implements _WebsocketStopSendPosition {
  const _$WebsocketStopSendPositionImpl(
      {this.type = "stop-send-user-position"});

  factory _$WebsocketStopSendPositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebsocketStopSendPositionImplFromJson(json);

  @override
  @JsonKey()
  final String type;

  @override
  String toString() {
    return 'WebsocketStopSendPosition(type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketStopSendPositionImpl &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketStopSendPositionImplCopyWith<_$WebsocketStopSendPositionImpl>
      get copyWith => __$$WebsocketStopSendPositionImplCopyWithImpl<
          _$WebsocketStopSendPositionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketStopSendPositionImplToJson(
      this,
    );
  }
}

abstract class _WebsocketStopSendPosition implements WebsocketStopSendPosition {
  const factory _WebsocketStopSendPosition({final String type}) =
      _$WebsocketStopSendPositionImpl;

  factory _WebsocketStopSendPosition.fromJson(Map<String, dynamic> json) =
      _$WebsocketStopSendPositionImpl.fromJson;

  @override
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketStopSendPositionImplCopyWith<_$WebsocketStopSendPositionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
