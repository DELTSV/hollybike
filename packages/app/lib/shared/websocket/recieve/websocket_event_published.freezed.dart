/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_event_published.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebsocketEventPublished _$WebsocketEventPublishedFromJson(
    Map<String, dynamic> json) {
  return _WebsocketEventPublished.fromJson(json);
}

/// @nodoc
mixin _$WebsocketEventPublished {
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_id')
  int get notificationId => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get start => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  int get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_name')
  String get ownerName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WebsocketEventPublishedCopyWith<WebsocketEventPublished> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsocketEventPublishedCopyWith<$Res> {
  factory $WebsocketEventPublishedCopyWith(WebsocketEventPublished value,
          $Res Function(WebsocketEventPublished) then) =
      _$WebsocketEventPublishedCopyWithImpl<$Res, WebsocketEventPublished>;
  @useResult
  $Res call(
      {String type,
      @JsonKey(name: 'notification_id') int notificationId,
      int id,
      String name,
      String? description,
      DateTime start,
      String? image,
      @JsonKey(name: 'owner_id') int ownerId,
      @JsonKey(name: 'owner_name') String ownerName});
}

/// @nodoc
class _$WebsocketEventPublishedCopyWithImpl<$Res,
        $Val extends WebsocketEventPublished>
    implements $WebsocketEventPublishedCopyWith<$Res> {
  _$WebsocketEventPublishedCopyWithImpl(this._value, this._then);

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
    Object? description = freezed,
    Object? start = null,
    Object? image = freezed,
    Object? ownerId = null,
    Object? ownerName = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as int,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebsocketEventPublishedImplCopyWith<$Res>
    implements $WebsocketEventPublishedCopyWith<$Res> {
  factory _$$WebsocketEventPublishedImplCopyWith(
          _$WebsocketEventPublishedImpl value,
          $Res Function(_$WebsocketEventPublishedImpl) then) =
      __$$WebsocketEventPublishedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      @JsonKey(name: 'notification_id') int notificationId,
      int id,
      String name,
      String? description,
      DateTime start,
      String? image,
      @JsonKey(name: 'owner_id') int ownerId,
      @JsonKey(name: 'owner_name') String ownerName});
}

/// @nodoc
class __$$WebsocketEventPublishedImplCopyWithImpl<$Res>
    extends _$WebsocketEventPublishedCopyWithImpl<$Res,
        _$WebsocketEventPublishedImpl>
    implements _$$WebsocketEventPublishedImplCopyWith<$Res> {
  __$$WebsocketEventPublishedImplCopyWithImpl(
      _$WebsocketEventPublishedImpl _value,
      $Res Function(_$WebsocketEventPublishedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? notificationId = null,
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? start = null,
    Object? image = freezed,
    Object? ownerId = null,
    Object? ownerName = null,
  }) {
    return _then(_$WebsocketEventPublishedImpl(
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as int,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WebsocketEventPublishedImpl implements _WebsocketEventPublished {
  const _$WebsocketEventPublishedImpl(
      {this.type = "NewEventNotification",
      @JsonKey(name: 'notification_id') required this.notificationId,
      required this.id,
      required this.name,
      this.description,
      required this.start,
      this.image,
      @JsonKey(name: 'owner_id') required this.ownerId,
      @JsonKey(name: 'owner_name') required this.ownerName});

  factory _$WebsocketEventPublishedImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebsocketEventPublishedImplFromJson(json);

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
  final String? description;
  @override
  final DateTime start;
  @override
  final String? image;
  @override
  @JsonKey(name: 'owner_id')
  final int ownerId;
  @override
  @JsonKey(name: 'owner_name')
  final String ownerName;

  @override
  String toString() {
    return 'WebsocketEventPublished(type: $type, notificationId: $notificationId, id: $id, name: $name, description: $description, start: $start, image: $image, ownerId: $ownerId, ownerName: $ownerName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebsocketEventPublishedImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, notificationId, id, name,
      description, start, image, ownerId, ownerName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebsocketEventPublishedImplCopyWith<_$WebsocketEventPublishedImpl>
      get copyWith => __$$WebsocketEventPublishedImplCopyWithImpl<
          _$WebsocketEventPublishedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebsocketEventPublishedImplToJson(
      this,
    );
  }
}

abstract class _WebsocketEventPublished implements WebsocketEventPublished {
  const factory _WebsocketEventPublished(
          {final String type,
          @JsonKey(name: 'notification_id') required final int notificationId,
          required final int id,
          required final String name,
          final String? description,
          required final DateTime start,
          final String? image,
          @JsonKey(name: 'owner_id') required final int ownerId,
          @JsonKey(name: 'owner_name') required final String ownerName}) =
      _$WebsocketEventPublishedImpl;

  factory _WebsocketEventPublished.fromJson(Map<String, dynamic> json) =
      _$WebsocketEventPublishedImpl.fromJson;

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
  String? get description;
  @override
  DateTime get start;
  @override
  String? get image;
  @override
  @JsonKey(name: 'owner_id')
  int get ownerId;
  @override
  @JsonKey(name: 'owner_name')
  String get ownerName;
  @override
  @JsonKey(ignore: true)
  _$$WebsocketEventPublishedImplCopyWith<_$WebsocketEventPublishedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
