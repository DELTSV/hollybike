/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'minimal_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MinimalEvent _$MinimalEventFromJson(Map<String, dynamic> json) {
  return _MinimalEvent.fromJson(json);
}

/// @nodoc
mixin _$MinimalEvent {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  MinimalUser get owner => throw _privateConstructorUsedError;
  EventStatusState get status => throw _privateConstructorUsedError;
  @JsonKey(name: "start_date_time")
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: "end_date_time")
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: "create_date_time")
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: "update_date_time")
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  @JsonKey(name: "image_key")
  String? get imageKey => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MinimalEventCopyWith<MinimalEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MinimalEventCopyWith<$Res> {
  factory $MinimalEventCopyWith(
          MinimalEvent value, $Res Function(MinimalEvent) then) =
      _$MinimalEventCopyWithImpl<$Res, MinimalEvent>;
  @useResult
  $Res call(
      {int id,
      String name,
      MinimalUser owner,
      EventStatusState status,
      @JsonKey(name: "start_date_time") DateTime startDate,
      @JsonKey(name: "end_date_time") DateTime? endDate,
      @JsonKey(name: "create_date_time") DateTime createdAt,
      @JsonKey(name: "update_date_time") DateTime updatedAt,
      String? description,
      String? image,
      @JsonKey(name: "image_key") String? imageKey});

  $MinimalUserCopyWith<$Res> get owner;
}

/// @nodoc
class _$MinimalEventCopyWithImpl<$Res, $Val extends MinimalEvent>
    implements $MinimalEventCopyWith<$Res> {
  _$MinimalEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? owner = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? description = freezed,
    Object? image = freezed,
    Object? imageKey = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as MinimalUser,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatusState,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      imageKey: freezed == imageKey
          ? _value.imageKey
          : imageKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MinimalUserCopyWith<$Res> get owner {
    return $MinimalUserCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MinimalEventImplCopyWith<$Res>
    implements $MinimalEventCopyWith<$Res> {
  factory _$$MinimalEventImplCopyWith(
          _$MinimalEventImpl value, $Res Function(_$MinimalEventImpl) then) =
      __$$MinimalEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      MinimalUser owner,
      EventStatusState status,
      @JsonKey(name: "start_date_time") DateTime startDate,
      @JsonKey(name: "end_date_time") DateTime? endDate,
      @JsonKey(name: "create_date_time") DateTime createdAt,
      @JsonKey(name: "update_date_time") DateTime updatedAt,
      String? description,
      String? image,
      @JsonKey(name: "image_key") String? imageKey});

  @override
  $MinimalUserCopyWith<$Res> get owner;
}

/// @nodoc
class __$$MinimalEventImplCopyWithImpl<$Res>
    extends _$MinimalEventCopyWithImpl<$Res, _$MinimalEventImpl>
    implements _$$MinimalEventImplCopyWith<$Res> {
  __$$MinimalEventImplCopyWithImpl(
      _$MinimalEventImpl _value, $Res Function(_$MinimalEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? owner = null,
    Object? status = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? description = freezed,
    Object? image = freezed,
    Object? imageKey = freezed,
  }) {
    return _then(_$MinimalEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as MinimalUser,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatusState,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      imageKey: freezed == imageKey
          ? _value.imageKey
          : imageKey // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MinimalEventImpl extends _MinimalEvent {
  const _$MinimalEventImpl(
      {required this.id,
      required this.name,
      required this.owner,
      required this.status,
      @JsonKey(name: "start_date_time") required this.startDate,
      @JsonKey(name: "end_date_time") this.endDate,
      @JsonKey(name: "create_date_time") required this.createdAt,
      @JsonKey(name: "update_date_time") required this.updatedAt,
      this.description,
      this.image,
      @JsonKey(name: "image_key") this.imageKey})
      : super._();

  factory _$MinimalEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$MinimalEventImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final MinimalUser owner;
  @override
  final EventStatusState status;
  @override
  @JsonKey(name: "start_date_time")
  final DateTime startDate;
  @override
  @JsonKey(name: "end_date_time")
  final DateTime? endDate;
  @override
  @JsonKey(name: "create_date_time")
  final DateTime createdAt;
  @override
  @JsonKey(name: "update_date_time")
  final DateTime updatedAt;
  @override
  final String? description;
  @override
  final String? image;
  @override
  @JsonKey(name: "image_key")
  final String? imageKey;

  @override
  String toString() {
    return 'MinimalEvent(id: $id, name: $name, owner: $owner, status: $status, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, image: $image, imageKey: $imageKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MinimalEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.imageKey, imageKey) ||
                other.imageKey == imageKey));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, owner, status,
      startDate, endDate, createdAt, updatedAt, description, image, imageKey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MinimalEventImplCopyWith<_$MinimalEventImpl> get copyWith =>
      __$$MinimalEventImplCopyWithImpl<_$MinimalEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MinimalEventImplToJson(
      this,
    );
  }
}

abstract class _MinimalEvent extends MinimalEvent {
  const factory _MinimalEvent(
      {required final int id,
      required final String name,
      required final MinimalUser owner,
      required final EventStatusState status,
      @JsonKey(name: "start_date_time") required final DateTime startDate,
      @JsonKey(name: "end_date_time") final DateTime? endDate,
      @JsonKey(name: "create_date_time") required final DateTime createdAt,
      @JsonKey(name: "update_date_time") required final DateTime updatedAt,
      final String? description,
      final String? image,
      @JsonKey(name: "image_key") final String? imageKey}) = _$MinimalEventImpl;
  const _MinimalEvent._() : super._();

  factory _MinimalEvent.fromJson(Map<String, dynamic> json) =
      _$MinimalEventImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  MinimalUser get owner;
  @override
  EventStatusState get status;
  @override
  @JsonKey(name: "start_date_time")
  DateTime get startDate;
  @override
  @JsonKey(name: "end_date_time")
  DateTime? get endDate;
  @override
  @JsonKey(name: "create_date_time")
  DateTime get createdAt;
  @override
  @JsonKey(name: "update_date_time")
  DateTime get updatedAt;
  @override
  String? get description;
  @override
  String? get image;
  @override
  @JsonKey(name: "image_key")
  String? get imageKey;
  @override
  @JsonKey(ignore: true)
  _$$MinimalEventImplCopyWith<_$MinimalEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
