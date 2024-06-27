// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventCandidate _$EventCandidateFromJson(Map<String, dynamic> json) {
  return _EventCandidate.fromJson(json);
}

/// @nodoc
mixin _$EventCandidate {
  int get id => throw _privateConstructorUsedError;

  String get username => throw _privateConstructorUsedError;

  @JsonKey(name: "is_owner")
  bool get isOwner => throw _privateConstructorUsedError;

  @JsonKey(name: "profile_picture")
  String? get profilePicture => throw _privateConstructorUsedError;

  @JsonKey(name: "event_role")
  EventRole? get eventRole => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventCandidateCopyWith<EventCandidate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCandidateCopyWith<$Res> {
  factory $EventCandidateCopyWith(
          EventCandidate value, $Res Function(EventCandidate) then) =
      _$EventCandidateCopyWithImpl<$Res, EventCandidate>;

  @useResult
  $Res call(
      {int id,
      String username,
      @JsonKey(name: "is_owner") bool isOwner,
      @JsonKey(name: "profile_picture") String? profilePicture,
      @JsonKey(name: "event_role") EventRole? eventRole});
}

/// @nodoc
class _$EventCandidateCopyWithImpl<$Res, $Val extends EventCandidate>
    implements $EventCandidateCopyWith<$Res> {
  _$EventCandidateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? isOwner = null,
    Object? profilePicture = freezed,
    Object? eventRole = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      eventRole: freezed == eventRole
          ? _value.eventRole
          : eventRole // ignore: cast_nullable_to_non_nullable
              as EventRole?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventCandidateImplCopyWith<$Res>
    implements $EventCandidateCopyWith<$Res> {
  factory _$$EventCandidateImplCopyWith(_$EventCandidateImpl value,
          $Res Function(_$EventCandidateImpl) then) =
      __$$EventCandidateImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call(
      {int id,
      String username,
      @JsonKey(name: "is_owner") bool isOwner,
      @JsonKey(name: "profile_picture") String? profilePicture,
      @JsonKey(name: "event_role") EventRole? eventRole});
}

/// @nodoc
class __$$EventCandidateImplCopyWithImpl<$Res>
    extends _$EventCandidateCopyWithImpl<$Res, _$EventCandidateImpl>
    implements _$$EventCandidateImplCopyWith<$Res> {
  __$$EventCandidateImplCopyWithImpl(
      _$EventCandidateImpl _value, $Res Function(_$EventCandidateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? isOwner = null,
    Object? profilePicture = freezed,
    Object? eventRole = freezed,
  }) {
    return _then(_$EventCandidateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      eventRole: freezed == eventRole
          ? _value.eventRole
          : eventRole // ignore: cast_nullable_to_non_nullable
              as EventRole?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventCandidateImpl implements _EventCandidate {
  const _$EventCandidateImpl(
      {required this.id,
      required this.username,
      @JsonKey(name: "is_owner") required this.isOwner,
      @JsonKey(name: "profile_picture") this.profilePicture,
      @JsonKey(name: "event_role") this.eventRole});

  factory _$EventCandidateImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventCandidateImplFromJson(json);

  @override
  final int id;
  @override
  final String username;
  @override
  @JsonKey(name: "is_owner")
  final bool isOwner;
  @override
  @JsonKey(name: "profile_picture")
  final String? profilePicture;
  @override
  @JsonKey(name: "event_role")
  final EventRole? eventRole;

  @override
  String toString() {
    return 'EventCandidate(id: $id, username: $username, isOwner: $isOwner, profilePicture: $profilePicture, eventRole: $eventRole)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventCandidateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.isOwner, isOwner) || other.isOwner == isOwner) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.eventRole, eventRole) ||
                other.eventRole == eventRole));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, username, isOwner, profilePicture, eventRole);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventCandidateImplCopyWith<_$EventCandidateImpl> get copyWith =>
      __$$EventCandidateImplCopyWithImpl<_$EventCandidateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventCandidateImplToJson(
      this,
    );
  }
}

abstract class _EventCandidate implements EventCandidate {
  const factory _EventCandidate(
          {required final int id,
          required final String username,
          @JsonKey(name: "is_owner") required final bool isOwner,
          @JsonKey(name: "profile_picture") final String? profilePicture,
          @JsonKey(name: "event_role") final EventRole? eventRole}) =
      _$EventCandidateImpl;

  factory _EventCandidate.fromJson(Map<String, dynamic> json) =
      _$EventCandidateImpl.fromJson;

  @override
  int get id;

  @override
  String get username;

  @override
  @JsonKey(name: "is_owner")
  bool get isOwner;

  @override
  @JsonKey(name: "profile_picture")
  String? get profilePicture;

  @override
  @JsonKey(name: "event_role")
  EventRole? get eventRole;

  @override
  @JsonKey(ignore: true)
  _$$EventCandidateImplCopyWith<_$EventCandidateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
