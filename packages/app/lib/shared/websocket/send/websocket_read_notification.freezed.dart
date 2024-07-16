/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_read_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketReadNotification _$WebsocketReadNotificationFromJson(
    Map<String, dynamic> json) {
  return _WebsocketReadNotification.fromJson(json);
}

/// @nodoc
mixin _$WebsocketReadNotification {
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification')
  int get notificationId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketReadNotificationCopyWith<WebsocketReadNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketReadNotificationCopyWith<$Res> {
  factory $WebsocketReadNotificationCopyWith(WebsocketReadNotification value,
          $Res Function(WebsocketReadNotification) then) =
      _$WebsocketReadNotificationCopyWithImpl<$Res, WebsocketReadNotification>;
  @useResult
  $Res call({String type, @JsonKey(name: 'notification') int notificationId});
}

/// @nodoc
class _$WebsocketReadNotificationCopyWithImpl<$Res,
        $Val extends WebsocketReadNotification>
    implements $WebsocketReadNotificationCopyWith<$Res> {
  _$WebsocketReadNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? notificationId = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketReadNotificationImplCopyWith<$Res>
    implements $WebsocketReadNotificationCopyWith<$Res> {
  factory _$$WebsocketReadNotificationImplCopyWith(
          _$WebsocketReadNotificationImpl value,
          $Res Function(_$WebsocketReadNotificationImpl) then) =
      __$$WebsocketReadNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, @JsonKey(name: 'notification') int notificationId});
}

/// @nodoc
class __$$WebsocketReadNotificationImplCopyWithImpl<$Res>
    extends _$WebsocketReadNotificationCopyWithImpl<$Res,
        _$WebsocketReadNotificationImpl>
    implements _$$WebsocketReadNotificationImplCopyWith<$Res> {
  __$$WebsocketReadNotificationImplCopyWithImpl(
      _$WebsocketReadNotificationImpl _value,
      $Res Function(_$WebsocketReadNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? notificationId = null,
  }) {
    return _then(_$WebsocketReadNotificationImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebsocketReadNotificationImpl implements _WebsocketReadNotification {
  const _$WebsocketReadNotificationImpl(
      {this.type = "read-notification",
      @JsonKey(name: 'notification') required this.notificationId});

  factory _$WebsocketReadNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebsocketReadNotificationImplFromJson(json);

  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey(name: 'notification')
  final int notificationId;

  @override
  String toString() {
    return 'WebsocketReadNotification(type: $type, notificationId: $notificationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketReadNotificationImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, notificationId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketReadNotificationImplCopyWith<_$WebsocketReadNotificationImpl>
      get copyWith => __$$WebsocketReadNotificationImplCopyWithImpl<
          _$WebsocketReadNotificationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketReadNotificationImplToJson(
      this,
    );
  }
}

abstract class _WebsocketReadNotification implements WebsocketReadNotification {
  const factory _WebsocketReadNotification(
          {final String type,
          @JsonKey(name: 'notification') required final int notificationId}) =
      _$WebsocketReadNotificationImpl;

  factory _WebsocketReadNotification.fromJson(Map<String, dynamic> json) =
      _$WebsocketReadNotificationImpl.fromJson;

  @override
  String get type;
  @override
  @JsonKey(name: 'notification')
  int get notificationId;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketReadNotificationImplCopyWith<_$WebsocketReadNotificationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
