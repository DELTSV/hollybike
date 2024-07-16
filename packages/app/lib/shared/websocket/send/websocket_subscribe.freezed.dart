/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_subscribe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketSubscribe _$WebsocketSubscribeFromJson(Map<String, dynamic> json) {
  return _WebsocketSubscribe.fromJson(json);
}

/// @nodoc
mixin _$WebsocketSubscribe {
  String get token => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketSubscribeCopyWith<WebsocketSubscribe> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketSubscribeCopyWith<$Res> {
  factory $WebsocketSubscribeCopyWith(
          WebsocketSubscribe value, $Res Function(WebsocketSubscribe) then) =
      _$WebsocketSubscribeCopyWithImpl<$Res, WebsocketSubscribe>;
  @useResult
  $Res call({String token, String type});
}

/// @nodoc
class _$WebsocketSubscribeCopyWithImpl<$Res, $Val extends WebsocketSubscribe>
    implements $WebsocketSubscribeCopyWith<$Res> {
  _$WebsocketSubscribeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketSubscribeImplCopyWith<$Res>
    implements $WebsocketSubscribeCopyWith<$Res> {
  factory _$$WebsocketSubscribeImplCopyWith(_$WebsocketSubscribeImpl value,
          $Res Function(_$WebsocketSubscribeImpl) then) =
      __$$WebsocketSubscribeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, String type});
}

/// @nodoc
class __$$WebsocketSubscribeImplCopyWithImpl<$Res>
    extends _$WebsocketSubscribeCopyWithImpl<$Res, _$WebsocketSubscribeImpl>
    implements _$$WebsocketSubscribeImplCopyWith<$Res> {
  __$$WebsocketSubscribeImplCopyWithImpl(_$WebsocketSubscribeImpl _value,
      $Res Function(_$WebsocketSubscribeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? type = null,
  }) {
    return _then(_$WebsocketSubscribeImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
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
class _$WebsocketSubscribeImpl implements _WebsocketSubscribe {
  const _$WebsocketSubscribeImpl(
      {required this.token, this.type = "subscribe"});

  factory _$WebsocketSubscribeImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebsocketSubscribeImplFromJson(json);

  @override
  final String token;
  @override
  @JsonKey()
  final String type;

  @override
  String toString() {
    return 'WebsocketSubscribe(token: $token, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketSubscribeImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, token, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketSubscribeImplCopyWith<_$WebsocketSubscribeImpl> get copyWith =>
      __$$WebsocketSubscribeImplCopyWithImpl<_$WebsocketSubscribeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketSubscribeImplToJson(
      this,
    );
  }
}

abstract class _WebsocketSubscribe implements WebsocketSubscribe {
  const factory _WebsocketSubscribe(
      {required final String token,
      final String type}) = _$WebsocketSubscribeImpl;

  factory _WebsocketSubscribe.fromJson(Map<String, dynamic> json) =
      _$WebsocketSubscribeImpl.fromJson;

  @override
  String get token;
  @override
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketSubscribeImplCopyWith<_$WebsocketSubscribeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
