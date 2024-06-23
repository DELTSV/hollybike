// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_subscribed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketSubscribed _$WebsocketSubscribedFromJson(Map<String, dynamic> json) {
  return _WebsocketSubscribed.fromJson(json);
}

/// @nodoc
mixin _$WebsocketSubscribed {
  bool get subscribed => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketSubscribedCopyWith<WebsocketSubscribed> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketSubscribedCopyWith<$Res> {
  factory $WebsocketSubscribedCopyWith(
          WebsocketSubscribed value, $Res Function(WebsocketSubscribed) then) =
      _$WebsocketSubscribedCopyWithImpl<$Res, WebsocketSubscribed>;
  @useResult
  $Res call({bool subscribed, String type});
}

/// @nodoc
class _$WebsocketSubscribedCopyWithImpl<$Res, $Val extends WebsocketSubscribed>
    implements $WebsocketSubscribedCopyWith<$Res> {
  _$WebsocketSubscribedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscribed = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      subscribed: null == subscribed
          ? _value.subscribed
          : subscribed // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketSubscribedImplCopyWith<$Res>
    implements $WebsocketSubscribedCopyWith<$Res> {
  factory _$$WebsocketSubscribedImplCopyWith(_$WebsocketSubscribedImpl value,
          $Res Function(_$WebsocketSubscribedImpl) then) =
      __$$WebsocketSubscribedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool subscribed, String type});
}

/// @nodoc
class __$$WebsocketSubscribedImplCopyWithImpl<$Res>
    extends _$WebsocketSubscribedCopyWithImpl<$Res, _$WebsocketSubscribedImpl>
    implements _$$WebsocketSubscribedImplCopyWith<$Res> {
  __$$WebsocketSubscribedImplCopyWithImpl(_$WebsocketSubscribedImpl _value,
      $Res Function(_$WebsocketSubscribedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscribed = null,
    Object? type = null,
  }) {
    return _then(_$WebsocketSubscribedImpl(
      subscribed: null == subscribed
          ? _value.subscribed
          : subscribed // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebsocketSubscribedImpl implements _WebsocketSubscribed {
  const _$WebsocketSubscribedImpl(
      {required this.subscribed, this.type = "subscribed"});

  factory _$WebsocketSubscribedImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebsocketSubscribedImplFromJson(json);

  @override
  final bool subscribed;
  @override
  @JsonKey()
  final String type;

  @override
  String toString() {
    return 'WebsocketSubscribed(subscribed: $subscribed, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketSubscribedImpl &&
            (identical(other.subscribed, subscribed) ||
                other.subscribed == subscribed) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, subscribed, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketSubscribedImplCopyWith<_$WebsocketSubscribedImpl> get copyWith =>
      __$$WebsocketSubscribedImplCopyWithImpl<_$WebsocketSubscribedImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketSubscribedImplToJson(
      this,
    );
  }
}

abstract class _WebsocketSubscribed implements WebsocketSubscribed {
  const factory _WebsocketSubscribed(
      {required final bool subscribed,
      final String type}) = _$WebsocketSubscribedImpl;

  factory _WebsocketSubscribed.fromJson(Map<String, dynamic> json) =
      _$WebsocketSubscribedImpl.fromJson;

  @override
  bool get subscribed;
  @override
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketSubscribedImplCopyWith<_$WebsocketSubscribedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
