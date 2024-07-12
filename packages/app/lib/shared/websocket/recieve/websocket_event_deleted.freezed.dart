// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_event_deleted.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketEventDeleted _$WebsocketEventDeletedFromJson(
    Map<String, dynamic> json) {
  return _WebsocketEventDeleted.fromJson(json);
}

/// @nodoc
mixin _$WebsocketEventDeleted {
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_id')
  int get notificationId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketEventDeletedCopyWith<WebsocketEventDeleted> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketEventDeletedCopyWith<$Res> {
  factory $WebsocketEventDeletedCopyWith(WebsocketEventDeleted value,
          $Res Function(WebsocketEventDeleted) then) =
      _$WebsocketEventDeletedCopyWithImpl<$Res, WebsocketEventDeleted>;
  @useResult
  $Res call(
      {String type,
      @JsonKey(name: 'notification_id') int notificationId,
      String name,
      String? description});
}

/// @nodoc
class _$WebsocketEventDeletedCopyWithImpl<$Res,
        $Val extends WebsocketEventDeleted>
    implements $WebsocketEventDeletedCopyWith<$Res> {
  _$WebsocketEventDeletedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? notificationId = null,
    Object? name = null,
    Object? description = freezed,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketEventDeletedImplCopyWith<$Res>
    implements $WebsocketEventDeletedCopyWith<$Res> {
  factory _$$WebsocketEventDeletedImplCopyWith(
          _$WebsocketEventDeletedImpl value,
          $Res Function(_$WebsocketEventDeletedImpl) then) =
      __$$WebsocketEventDeletedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      @JsonKey(name: 'notification_id') int notificationId,
      String name,
      String? description});
}

/// @nodoc
class __$$WebsocketEventDeletedImplCopyWithImpl<$Res>
    extends _$WebsocketEventDeletedCopyWithImpl<$Res,
        _$WebsocketEventDeletedImpl>
    implements _$$WebsocketEventDeletedImplCopyWith<$Res> {
  __$$WebsocketEventDeletedImplCopyWithImpl(_$WebsocketEventDeletedImpl _value,
      $Res Function(_$WebsocketEventDeletedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? notificationId = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(_$WebsocketEventDeletedImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebsocketEventDeletedImpl implements _WebsocketEventDeleted {
  const _$WebsocketEventDeletedImpl(
      {this.type = "DeleteEventNotification",
      @JsonKey(name: 'notification_id') required this.notificationId,
      required this.name,
      this.description});

  factory _$WebsocketEventDeletedImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebsocketEventDeletedImplFromJson(json);

  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey(name: 'notification_id')
  final int notificationId;
  @override
  final String name;
  @override
  final String? description;

  @override
  String toString() {
    return 'WebsocketEventDeleted(type: $type, notificationId: $notificationId, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketEventDeletedImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, notificationId, name, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketEventDeletedImplCopyWith<_$WebsocketEventDeletedImpl>
      get copyWith => __$$WebsocketEventDeletedImplCopyWithImpl<
          _$WebsocketEventDeletedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketEventDeletedImplToJson(
      this,
    );
  }
}

abstract class _WebsocketEventDeleted implements WebsocketEventDeleted {
  const factory _WebsocketEventDeleted(
      {final String type,
      @JsonKey(name: 'notification_id') required final int notificationId,
      required final String name,
      final String? description}) = _$WebsocketEventDeletedImpl;

  factory _WebsocketEventDeleted.fromJson(Map<String, dynamic> json) =
      _$WebsocketEventDeletedImpl.fromJson;

  @override
  String get type;
  @override
  @JsonKey(name: 'notification_id')
  int get notificationId;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketEventDeletedImplCopyWith<_$WebsocketEventDeletedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
