// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_caller_participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventCallerParticipation _$EventCallerParticipationFromJson(
    Map<String, dynamic> json) {
  return _EventCallerParticipation.fromJson(json);
}

/// @nodoc
mixin _$EventCallerParticipation {
  int get userId => throw _privateConstructorUsedError;
  bool get isImagesPublic => throw _privateConstructorUsedError;
  EventRole get role => throw _privateConstructorUsedError;
  DateTime get joinedDateTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCallerParticipationCopyWith<EventCallerParticipation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCallerParticipationCopyWith<$Res> {
  factory $EventCallerParticipationCopyWith(EventCallerParticipation value,
          $Res Function(EventCallerParticipation) then) =
      _$EventCallerParticipationCopyWithImpl<$Res, EventCallerParticipation>;
  @useResult
  $Res call(
      {int userId,
      bool isImagesPublic,
      EventRole role,
      DateTime joinedDateTime});
}

/// @nodoc
class _$EventCallerParticipationCopyWithImpl<$Res,
        $Val extends EventCallerParticipation>
    implements $EventCallerParticipationCopyWith<$Res> {
  _$EventCallerParticipationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? isImagesPublic = null,
    Object? role = null,
    Object? joinedDateTime = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      isImagesPublic: null == isImagesPublic
          ? _value.isImagesPublic
          : isImagesPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as EventRole,
      joinedDateTime: null == joinedDateTime
          ? _value.joinedDateTime
          : joinedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventCallerParticipationImplCopyWith<$Res>
    implements $EventCallerParticipationCopyWith<$Res> {
  factory _$$EventCallerParticipationImplCopyWith(
          _$EventCallerParticipationImpl value,
          $Res Function(_$EventCallerParticipationImpl) then) =
      __$$EventCallerParticipationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int userId,
      bool isImagesPublic,
      EventRole role,
      DateTime joinedDateTime});
}

/// @nodoc
class __$$EventCallerParticipationImplCopyWithImpl<$Res>
    extends _$EventCallerParticipationCopyWithImpl<$Res,
        _$EventCallerParticipationImpl>
    implements _$$EventCallerParticipationImplCopyWith<$Res> {
  __$$EventCallerParticipationImplCopyWithImpl(
      _$EventCallerParticipationImpl _value,
      $Res Function(_$EventCallerParticipationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? isImagesPublic = null,
    Object? role = null,
    Object? joinedDateTime = null,
  }) {
    return _then(_$EventCallerParticipationImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      isImagesPublic: null == isImagesPublic
          ? _value.isImagesPublic
          : isImagesPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as EventRole,
      joinedDateTime: null == joinedDateTime
          ? _value.joinedDateTime
          : joinedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventCallerParticipationImpl implements _EventCallerParticipation {
  const _$EventCallerParticipationImpl(
      {required this.userId,
      required this.isImagesPublic,
      required this.role,
      required this.joinedDateTime});

  factory _$EventCallerParticipationImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventCallerParticipationImplFromJson(json);

  @override
  final int userId;
  @override
  final bool isImagesPublic;
  @override
  final EventRole role;
  @override
  final DateTime joinedDateTime;

  @override
  String toString() {
    return 'EventCallerParticipation(userId: $userId, isImagesPublic: $isImagesPublic, role: $role, joinedDateTime: $joinedDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventCallerParticipationImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.isImagesPublic, isImagesPublic) ||
                other.isImagesPublic == isImagesPublic) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinedDateTime, joinedDateTime) ||
                other.joinedDateTime == joinedDateTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, isImagesPublic, role, joinedDateTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventCallerParticipationImplCopyWith<_$EventCallerParticipationImpl>
      get copyWith => __$$EventCallerParticipationImplCopyWithImpl<
          _$EventCallerParticipationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventCallerParticipationImplToJson(
      this,
    );
  }
}

abstract class _EventCallerParticipation implements EventCallerParticipation {
  const factory _EventCallerParticipation(
      {required final int userId,
      required final bool isImagesPublic,
      required final EventRole role,
      required final DateTime joinedDateTime}) = _$EventCallerParticipationImpl;

  factory _EventCallerParticipation.fromJson(Map<String, dynamic> json) =
      _$EventCallerParticipationImpl.fromJson;

  @override
  int get userId;
  @override
  bool get isImagesPublic;
  @override
  EventRole get role;
  @override
  DateTime get joinedDateTime;
  @override
  @JsonKey(ignore: true)
  _$$EventCallerParticipationImplCopyWith<_$EventCallerParticipationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
