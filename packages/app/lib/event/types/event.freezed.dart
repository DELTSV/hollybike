// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
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
  int? get budget => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
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
      int? budget});

  $MinimalUserCopyWith<$Res> get owner;
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

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
    Object? budget = freezed,
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
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$EventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$EventImplCopyWith(
          _$EventImpl value, $Res Function(_$EventImpl) then) =
      __$$EventImplCopyWithImpl<$Res>;
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
      int? budget});

  @override
  $MinimalUserCopyWith<$Res> get owner;
}

/// @nodoc
class __$$EventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$EventImpl>
    implements _$$EventImplCopyWith<$Res> {
  __$$EventImplCopyWithImpl(
      _$EventImpl _value, $Res Function(_$EventImpl) _then)
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
    Object? budget = freezed,
  }) {
    return _then(_$EventImpl(
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
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImpl extends _Event {
  const _$EventImpl(
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
      this.budget})
      : super._();

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

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
  final int? budget;

  @override
  String toString() {
    return 'Event(id: $id, name: $name, owner: $owner, status: $status, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, image: $image, budget: $budget)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
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
            (identical(other.budget, budget) || other.budget == budget));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, owner, status,
      startDate, endDate, createdAt, updatedAt, description, image, budget);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      __$$EventImplCopyWithImpl<_$EventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImplToJson(
      this,
    );
  }
}

abstract class _Event extends Event {
  const factory _Event(
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
      final int? budget}) = _$EventImpl;
  const _Event._() : super._();

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

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
  int? get budget;
  @override
  @JsonKey(ignore: true)
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
