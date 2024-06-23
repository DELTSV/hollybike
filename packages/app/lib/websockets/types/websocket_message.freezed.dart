// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketMessage<T> _$WebsocketMessageFromJson<T extends WebsocketBody>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _WebsocketMessage<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$WebsocketMessage<T extends WebsocketBody> {
  String get channel => throw _privateConstructorUsedError;
  T get data => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketMessageCopyWith<T, WebsocketMessage<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketMessageCopyWith<T extends WebsocketBody, $Res> {
  factory $WebsocketMessageCopyWith(
          WebsocketMessage<T> value, $Res Function(WebsocketMessage<T>) then) =
      _$WebsocketMessageCopyWithImpl<T, $Res, WebsocketMessage<T>>;
  @useResult
  $Res call({String channel, T data});
}

/// @nodoc
class _$WebsocketMessageCopyWithImpl<T extends WebsocketBody, $Res,
        $Val extends WebsocketMessage<T>>
    implements $WebsocketMessageCopyWith<T, $Res> {
  _$WebsocketMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketMessageImplCopyWith<T extends WebsocketBody, $Res>
    implements $WebsocketMessageCopyWith<T, $Res> {
  factory _$$WebsocketMessageImplCopyWith(_$WebsocketMessageImpl<T> value,
          $Res Function(_$WebsocketMessageImpl<T>) then) =
      __$$WebsocketMessageImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({String channel, T data});
}

/// @nodoc
class __$$WebsocketMessageImplCopyWithImpl<T extends WebsocketBody, $Res>
    extends _$WebsocketMessageCopyWithImpl<T, $Res, _$WebsocketMessageImpl<T>>
    implements _$$WebsocketMessageImplCopyWith<T, $Res> {
  __$$WebsocketMessageImplCopyWithImpl(_$WebsocketMessageImpl<T> _value,
      $Res Function(_$WebsocketMessageImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? data = null,
  }) {
    return _then(_$WebsocketMessageImpl<T>(
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$WebsocketMessageImpl<T extends WebsocketBody>
    implements _WebsocketMessage<T> {
  const _$WebsocketMessageImpl({required this.channel, required this.data});

  factory _$WebsocketMessageImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$WebsocketMessageImplFromJson(json, fromJsonT);

  @override
  final String channel;
  @override
  final T data;

  @override
  String toString() {
    return 'WebsocketMessage<$T>(channel: $channel, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketMessageImpl<T> &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, channel, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketMessageImplCopyWith<T, _$WebsocketMessageImpl<T>> get copyWith =>
      __$$WebsocketMessageImplCopyWithImpl<T, _$WebsocketMessageImpl<T>>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$WebsocketMessageImplToJson<T>(this, toJsonT);
  }
}

abstract class _WebsocketMessage<T extends WebsocketBody>
    implements WebsocketMessage<T> {
  const factory _WebsocketMessage(
      {required final String channel,
      required final T data}) = _$WebsocketMessageImpl<T>;

  factory _WebsocketMessage.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$WebsocketMessageImpl<T>.fromJson;

  @override
  String get channel;
  @override
  T get data;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketMessageImplCopyWith<T, _$WebsocketMessageImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
