// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'minimal_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MinimalUser _$MinimalUserFromJson(Map<String, dynamic> json) {
  return _MinimalUser.fromJson(json);
}

/// @nodoc
mixin _$MinimalUser {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  UserScope get scope => throw _privateConstructorUsedError;
  UserStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: "profile_picture")
  String? get profilePicture => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MinimalUserCopyWith<MinimalUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MinimalUserCopyWith<$Res> {
  factory $MinimalUserCopyWith(
          MinimalUser value, $Res Function(MinimalUser) then) =
      _$MinimalUserCopyWithImpl<$Res, MinimalUser>;
  @useResult
  $Res call(
      {int id,
      String username,
      UserScope scope,
      UserStatus status,
      @JsonKey(name: "profile_picture") String? profilePicture});
}

/// @nodoc
class _$MinimalUserCopyWithImpl<$Res, $Val extends MinimalUser>
    implements $MinimalUserCopyWith<$Res> {
  _$MinimalUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? scope = null,
    Object? status = null,
    Object? profilePicture = freezed,
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
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as UserScope,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MinimalUserImplCopyWith<$Res>
    implements $MinimalUserCopyWith<$Res> {
  factory _$$MinimalUserImplCopyWith(
          _$MinimalUserImpl value, $Res Function(_$MinimalUserImpl) then) =
      __$$MinimalUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String username,
      UserScope scope,
      UserStatus status,
      @JsonKey(name: "profile_picture") String? profilePicture});
}

/// @nodoc
class __$$MinimalUserImplCopyWithImpl<$Res>
    extends _$MinimalUserCopyWithImpl<$Res, _$MinimalUserImpl>
    implements _$$MinimalUserImplCopyWith<$Res> {
  __$$MinimalUserImplCopyWithImpl(
      _$MinimalUserImpl _value, $Res Function(_$MinimalUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? scope = null,
    Object? status = null,
    Object? profilePicture = freezed,
  }) {
    return _then(_$MinimalUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as UserScope,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MinimalUserImpl with DiagnosticableTreeMixin implements _MinimalUser {
  const _$MinimalUserImpl(
      {required this.id,
      required this.username,
      required this.scope,
      required this.status,
      @JsonKey(name: "profile_picture") this.profilePicture});

  factory _$MinimalUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$MinimalUserImplFromJson(json);

  @override
  final int id;
  @override
  final String username;
  @override
  final UserScope scope;
  @override
  final UserStatus status;
  @override
  @JsonKey(name: "profile_picture")
  final String? profilePicture;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MinimalUser(id: $id, username: $username, scope: $scope, status: $status, profilePicture: $profilePicture)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MinimalUser'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('username', username))
      ..add(DiagnosticsProperty('scope', scope))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('profilePicture', profilePicture));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MinimalUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, username, scope, status, profilePicture);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MinimalUserImplCopyWith<_$MinimalUserImpl> get copyWith =>
      __$$MinimalUserImplCopyWithImpl<_$MinimalUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MinimalUserImplToJson(
      this,
    );
  }
}

abstract class _MinimalUser implements MinimalUser {
  const factory _MinimalUser(
          {required final int id,
          required final String username,
          required final UserScope scope,
          required final UserStatus status,
          @JsonKey(name: "profile_picture") final String? profilePicture}) =
      _$MinimalUserImpl;

  factory _MinimalUser.fromJson(Map<String, dynamic> json) =
      _$MinimalUserImpl.fromJson;

  @override
  int get id;
  @override
  String get username;
  @override
  UserScope get scope;
  @override
  UserStatus get status;
  @override
  @JsonKey(name: "profile_picture")
  String? get profilePicture;
  @override
  @JsonKey(ignore: true)
  _$$MinimalUserImplCopyWith<_$MinimalUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
