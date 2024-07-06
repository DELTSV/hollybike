// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_removed_from_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketRemovedFromEvent _$WebsocketRemovedFromEventFromJson(
    Map<String, dynamic> json) {
  return _WebsocketRemovedFromEvent.fromJson(json);
}

/// @nodoc
mixin _$WebsocketRemovedFromEvent {
  String get type => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketRemovedFromEventCopyWith<WebsocketRemovedFromEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketRemovedFromEventCopyWith<$Res> {
  factory $WebsocketRemovedFromEventCopyWith(WebsocketRemovedFromEvent value,
          $Res Function(WebsocketRemovedFromEvent) then) =
      _$WebsocketRemovedFromEventCopyWithImpl<$Res, WebsocketRemovedFromEvent>;
  @useResult
  $Res call({String type, int id, String name});
}

/// @nodoc
class _$WebsocketRemovedFromEventCopyWithImpl<$Res,
        $Val extends WebsocketRemovedFromEvent>
    implements $WebsocketRemovedFromEventCopyWith<$Res> {
  _$WebsocketRemovedFromEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$WebsocketRemovedFromEventImplCopyWith<$Res>
    implements $WebsocketRemovedFromEventCopyWith<$Res> {
  factory _$$WebsocketRemovedFromEventImplCopyWith(
          _$WebsocketRemovedFromEventImpl value,
          $Res Function(_$WebsocketRemovedFromEventImpl) then) =
      __$$WebsocketRemovedFromEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, int id, String name});
}

/// @nodoc
class __$$WebsocketRemovedFromEventImplCopyWithImpl<$Res>
    extends _$WebsocketRemovedFromEventCopyWithImpl<$Res,
        _$WebsocketRemovedFromEventImpl>
    implements _$$WebsocketRemovedFromEventImplCopyWith<$Res> {
  __$$WebsocketRemovedFromEventImplCopyWithImpl(
      _$WebsocketRemovedFromEventImpl _value,
      $Res Function(_$WebsocketRemovedFromEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$WebsocketRemovedFromEventImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$WebsocketRemovedFromEventImpl implements _WebsocketRemovedFromEvent {
  const _$WebsocketRemovedFromEventImpl(
      {this.type = "RemovedFromEventNotification",
      required this.id,
      required this.name});

  factory _$WebsocketRemovedFromEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebsocketRemovedFromEventImplFromJson(json);

  @override
  @JsonKey()
  final String type;
  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'WebsocketRemovedFromEvent(type: $type, id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketRemovedFromEventImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketRemovedFromEventImplCopyWith<_$WebsocketRemovedFromEventImpl>
      get copyWith => __$$WebsocketRemovedFromEventImplCopyWithImpl<
          _$WebsocketRemovedFromEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketRemovedFromEventImplToJson(
      this,
    );
  }
}

abstract class _WebsocketRemovedFromEvent implements WebsocketRemovedFromEvent {
  const factory _WebsocketRemovedFromEvent(
      {final String type,
      required final int id,
      required final String name}) = _$WebsocketRemovedFromEventImpl;

  factory _WebsocketRemovedFromEvent.fromJson(Map<String, dynamic> json) =
      _$WebsocketRemovedFromEventImpl.fromJson;

  @override
  String get type;
  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketRemovedFromEventImplCopyWith<_$WebsocketRemovedFromEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}
