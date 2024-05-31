// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_participation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventParticipation _$EventParticipationFromJson(Map<String, dynamic> json) {
  return _EventParticipation.fromJson(json);
}

/// @nodoc
mixin _$EventParticipation {
  MinimalUser get user => throw _privateConstructorUsedError;
  bool get isImagesPublic => throw _privateConstructorUsedError;
  EventRole get role => throw _privateConstructorUsedError;
  DateTime get joinedDateTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventParticipationCopyWith<EventParticipation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventParticipationCopyWith<$Res> {
  factory $EventParticipationCopyWith(
          EventParticipation value, $Res Function(EventParticipation) then) =
      _$EventParticipationCopyWithImpl<$Res, EventParticipation>;
  @useResult
  $Res call(
      {MinimalUser user,
      bool isImagesPublic,
      EventRole role,
      DateTime joinedDateTime});

  $MinimalUserCopyWith<$Res> get user;
}

/// @nodoc
class _$EventParticipationCopyWithImpl<$Res, $Val extends EventParticipation>
    implements $EventParticipationCopyWith<$Res> {
  _$EventParticipationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? isImagesPublic = null,
    Object? role = null,
    Object? joinedDateTime = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as MinimalUser,
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

  @override
  @pragma('vm:prefer-inline')
  $MinimalUserCopyWith<$Res> get user {
    return $MinimalUserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventParticipationImplCopyWith<$Res>
    implements $EventParticipationCopyWith<$Res> {
  factory _$$EventParticipationImplCopyWith(_$EventParticipationImpl value,
          $Res Function(_$EventParticipationImpl) then) =
      __$$EventParticipationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MinimalUser user,
      bool isImagesPublic,
      EventRole role,
      DateTime joinedDateTime});

  @override
  $MinimalUserCopyWith<$Res> get user;
}

/// @nodoc
class __$$EventParticipationImplCopyWithImpl<$Res>
    extends _$EventParticipationCopyWithImpl<$Res, _$EventParticipationImpl>
    implements _$$EventParticipationImplCopyWith<$Res> {
  __$$EventParticipationImplCopyWithImpl(_$EventParticipationImpl _value,
      $Res Function(_$EventParticipationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? isImagesPublic = null,
    Object? role = null,
    Object? joinedDateTime = null,
  }) {
    return _then(_$EventParticipationImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as MinimalUser,
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
class _$EventParticipationImpl implements _EventParticipation {
  const _$EventParticipationImpl(
      {required this.user,
      required this.isImagesPublic,
      required this.role,
      required this.joinedDateTime});

  factory _$EventParticipationImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventParticipationImplFromJson(json);

  @override
  final MinimalUser user;
  @override
  final bool isImagesPublic;
  @override
  final EventRole role;
  @override
  final DateTime joinedDateTime;

  @override
  String toString() {
    return 'EventParticipation(user: $user, isImagesPublic: $isImagesPublic, role: $role, joinedDateTime: $joinedDateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventParticipationImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isImagesPublic, isImagesPublic) ||
                other.isImagesPublic == isImagesPublic) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinedDateTime, joinedDateTime) ||
                other.joinedDateTime == joinedDateTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, user, isImagesPublic, role, joinedDateTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventParticipationImplCopyWith<_$EventParticipationImpl> get copyWith =>
      __$$EventParticipationImplCopyWithImpl<_$EventParticipationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventParticipationImplToJson(
      this,
    );
  }
}

abstract class _EventParticipation implements EventParticipation {
  const factory _EventParticipation(
      {required final MinimalUser user,
      required final bool isImagesPublic,
      required final EventRole role,
      required final DateTime joinedDateTime}) = _$EventParticipationImpl;

  factory _EventParticipation.fromJson(Map<String, dynamic> json) =
      _$EventParticipationImpl.fromJson;

  @override
  MinimalUser get user;
  @override
  bool get isImagesPublic;
  @override
  EventRole get role;
  @override
  DateTime get joinedDateTime;
  @override
  @JsonKey(ignore: true)
  _$$EventParticipationImplCopyWith<_$EventParticipationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
