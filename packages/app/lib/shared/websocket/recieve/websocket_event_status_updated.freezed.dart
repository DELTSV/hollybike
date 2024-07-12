// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_event_status_updated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketEventStatusUpdated _$WebsocketEventStatusUpdatedFromJson(
    Map<String, dynamic> json) {
  return _WebsocketEventStatusUpdated.fromJson(json);
}

/// @nodoc
mixin _$WebsocketEventStatusUpdated {
  String get type => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_id')
  int get notificationId => throw _privateConstructorUsedError;
  EventStatusState get status => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketEventStatusUpdatedCopyWith<WebsocketEventStatusUpdated>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketEventStatusUpdatedCopyWith<$Res> {
  factory $WebsocketEventStatusUpdatedCopyWith(
          WebsocketEventStatusUpdated value,
          $Res Function(WebsocketEventStatusUpdated) then) =
      _$WebsocketEventStatusUpdatedCopyWithImpl<$Res,
          WebsocketEventStatusUpdated>;
  @useResult
  $Res call(
      {String type,
      int id,
      @JsonKey(name: 'notification_id') int notificationId,
      EventStatusState status,
      String name,
      String? description,
      String? image});
}

/// @nodoc
class _$WebsocketEventStatusUpdatedCopyWithImpl<$Res,
        $Val extends WebsocketEventStatusUpdated>
    implements $WebsocketEventStatusUpdatedCopyWith<$Res> {
  _$WebsocketEventStatusUpdatedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = null,
    Object? notificationId = null,
    Object? status = null,
    Object? name = null,
    Object? description = freezed,
    Object? image = freezed,
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
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatusState,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketEventStatusUpdatedImplCopyWith<$Res>
    implements $WebsocketEventStatusUpdatedCopyWith<$Res> {
  factory _$$WebsocketEventStatusUpdatedImplCopyWith(
          _$WebsocketEventStatusUpdatedImpl value,
          $Res Function(_$WebsocketEventStatusUpdatedImpl) then) =
      __$$WebsocketEventStatusUpdatedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      int id,
      @JsonKey(name: 'notification_id') int notificationId,
      EventStatusState status,
      String name,
      String? description,
      String? image});
}

/// @nodoc
class __$$WebsocketEventStatusUpdatedImplCopyWithImpl<$Res>
    extends _$WebsocketEventStatusUpdatedCopyWithImpl<$Res,
        _$WebsocketEventStatusUpdatedImpl>
    implements _$$WebsocketEventStatusUpdatedImplCopyWith<$Res> {
  __$$WebsocketEventStatusUpdatedImplCopyWithImpl(
      _$WebsocketEventStatusUpdatedImpl _value,
      $Res Function(_$WebsocketEventStatusUpdatedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = null,
    Object? notificationId = null,
    Object? status = null,
    Object? name = null,
    Object? description = freezed,
    Object? image = freezed,
  }) {
    return _then(_$WebsocketEventStatusUpdatedImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      notificationId: null == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatusState,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebsocketEventStatusUpdatedImpl
    implements _WebsocketEventStatusUpdated {
  const _$WebsocketEventStatusUpdatedImpl(
      {this.type = "EventStatusUpdateNotification",
      required this.id,
      @JsonKey(name: 'notification_id') required this.notificationId,
      required this.status,
      required this.name,
      this.description,
      this.image});

  factory _$WebsocketEventStatusUpdatedImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$WebsocketEventStatusUpdatedImplFromJson(json);

  @override
  @JsonKey()
  final String type;
  @override
  final int id;
  @override
  @JsonKey(name: 'notification_id')
  final int notificationId;
  @override
  final EventStatusState status;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? image;

  @override
  String toString() {
    return 'WebsocketEventStatusUpdated(type: $type, id: $id, notificationId: $notificationId, status: $status, name: $name, description: $description, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketEventStatusUpdatedImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, id, notificationId, status, name, description, image);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketEventStatusUpdatedImplCopyWith<_$WebsocketEventStatusUpdatedImpl>
      get copyWith => __$$WebsocketEventStatusUpdatedImplCopyWithImpl<
          _$WebsocketEventStatusUpdatedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketEventStatusUpdatedImplToJson(
      this,
    );
  }
}

abstract class _WebsocketEventStatusUpdated
    implements WebsocketEventStatusUpdated {
  const factory _WebsocketEventStatusUpdated(
      {final String type,
      required final int id,
      @JsonKey(name: 'notification_id') required final int notificationId,
      required final EventStatusState status,
      required final String name,
      final String? description,
      final String? image}) = _$WebsocketEventStatusUpdatedImpl;

  factory _WebsocketEventStatusUpdated.fromJson(Map<String, dynamic> json) =
      _$WebsocketEventStatusUpdatedImpl.fromJson;

  @override
  String get type;
  @override
  int get id;
  @override
  @JsonKey(name: 'notification_id')
  int get notificationId;
  @override
  EventStatusState get status;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get image;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketEventStatusUpdatedImplCopyWith<_$WebsocketEventStatusUpdatedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
