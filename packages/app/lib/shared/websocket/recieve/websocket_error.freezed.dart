/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketError _$WebsocketErrorFromJson(Map<String, dynamic> json) {
  return _WebsocketError.fromJson(json);
}

/// @nodoc
mixin _$WebsocketError {
  String get message => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketErrorCopyWith<WebsocketError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketErrorCopyWith<$Res> {
  factory $WebsocketErrorCopyWith(
          WebsocketError value, $Res Function(WebsocketError) then) =
      _$WebsocketErrorCopyWithImpl<$Res, WebsocketError>;
  @useResult
  $Res call({String message, String type});
}

/// @nodoc
class _$WebsocketErrorCopyWithImpl<$Res, $Val extends WebsocketError>
    implements $WebsocketErrorCopyWith<$Res> {
  _$WebsocketErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketErrorImplCopyWith<$Res>
    implements $WebsocketErrorCopyWith<$Res> {
  factory _$$WebsocketErrorImplCopyWith(_$WebsocketErrorImpl value,
          $Res Function(_$WebsocketErrorImpl) then) =
      __$$WebsocketErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String type});
}

/// @nodoc
class __$$WebsocketErrorImplCopyWithImpl<$Res>
    extends _$WebsocketErrorCopyWithImpl<$Res, _$WebsocketErrorImpl>
    implements _$$WebsocketErrorImplCopyWith<$Res> {
  __$$WebsocketErrorImplCopyWithImpl(
      _$WebsocketErrorImpl _value, $Res Function(_$WebsocketErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? type = null,
  }) {
    return _then(_$WebsocketErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebsocketErrorImpl implements _WebsocketError {
  const _$WebsocketErrorImpl({required this.message, this.type = "subscribed"});

  factory _$WebsocketErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebsocketErrorImplFromJson(json);

  @override
  final String message;
  @override
  @JsonKey()
  final String type;

  @override
  String toString() {
    return 'WebsocketError(message: $message, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketErrorImplCopyWith<_$WebsocketErrorImpl> get copyWith =>
      __$$WebsocketErrorImplCopyWithImpl<_$WebsocketErrorImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketErrorImplToJson(
      this,
    );
  }
}

abstract class _WebsocketError implements WebsocketError {
  const factory _WebsocketError(
      {required final String message,
      final String type}) = _$WebsocketErrorImpl;

  factory _WebsocketError.fromJson(Map<String, dynamic> json) =
      _$WebsocketErrorImpl.fromJson;

  @override
  String get message;
  @override
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketErrorImplCopyWith<_$WebsocketErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
