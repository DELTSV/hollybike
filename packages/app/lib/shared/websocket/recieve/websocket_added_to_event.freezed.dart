/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_added_to_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketAddedToEvent _$WebsocketAddedToEventFromJson(
    Map<String, dynamic> json) {
  return _WebsocketAddedToEvent.fromJson(json);
}

/// @nodoc
mixin _$WebsocketAddedToEvent {
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_id')
  int get notificationId => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketAddedToEventCopyWith<WebsocketAddedToEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketAddedToEventCopyWith<$Res> {
  factory $WebsocketAddedToEventCopyWith(WebsocketAddedToEvent value,
          $Res Function(WebsocketAddedToEvent) then) =
      _$WebsocketAddedToEventCopyWithImpl<$Res, WebsocketAddedToEvent>;
  @useResult
  $Res call(
      {String type,
      @JsonKey(name: 'notification_id') int notificationId,
      int id,
      String name});
}

/// @nodoc
class _$WebsocketAddedToEventCopyWithImpl<$Res,
        $Val extends WebsocketAddedToEvent>
    implements $WebsocketAddedToEventCopyWith<$Res> {
  _$WebsocketAddedToEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? notificationId = null,
    Object? id = null,
    Object? name = null,
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
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketAddedToEventImplCopyWith<$Res>
    implements $WebsocketAddedToEventCopyWith<$Res> {
  factory _$$WebsocketAddedToEventImplCopyWith(
          _$WebsocketAddedToEventImpl value,
          $Res Function(_$WebsocketAddedToEventImpl) then) =
      __$$WebsocketAddedToEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      @JsonKey(name: 'notification_id') int notificationId,
      int id,
      String name});
}

/// @nodoc
class __$$WebsocketAddedToEventImplCopyWithImpl<$Res>
    extends _$WebsocketAddedToEventCopyWithImpl<$Res,
        _$WebsocketAddedToEventImpl>
    implements _$$WebsocketAddedToEventImplCopyWith<$Res> {
  __$$WebsocketAddedToEventImplCopyWithImpl(_$WebsocketAddedToEventImpl _value,
      $Res Function(_$WebsocketAddedToEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? notificationId = null,
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$WebsocketAddedToEventImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebsocketAddedToEventImpl implements _WebsocketAddedToEvent {
  const _$WebsocketAddedToEventImpl(
      {this.type = "AddedToEventNotification",
      @JsonKey(name: 'notification_id') required this.notificationId,
      required this.id,
      required this.name});

  factory _$WebsocketAddedToEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebsocketAddedToEventImplFromJson(json);

  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey(name: 'notification_id')
  final int notificationId;
  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'WebsocketAddedToEvent(type: $type, notificationId: $notificationId, id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketAddedToEventImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, notificationId, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketAddedToEventImplCopyWith<_$WebsocketAddedToEventImpl>
      get copyWith => __$$WebsocketAddedToEventImplCopyWithImpl<
          _$WebsocketAddedToEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketAddedToEventImplToJson(
      this,
    );
  }
}

abstract class _WebsocketAddedToEvent implements WebsocketAddedToEvent {
  const factory _WebsocketAddedToEvent(
      {final String type,
      @JsonKey(name: 'notification_id') required final int notificationId,
      required final int id,
      required final String name}) = _$WebsocketAddedToEventImpl;

  factory _WebsocketAddedToEvent.fromJson(Map<String, dynamic> json) =
      _$WebsocketAddedToEventImpl.fromJson;

  @override
  String get type;
  @override
  @JsonKey(name: 'notification_id')
  int get notificationId;
  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketAddedToEventImplCopyWith<_$WebsocketAddedToEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
