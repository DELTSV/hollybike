/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_password.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdatePassword _$UpdatePasswordFromJson(Map<String, dynamic> json) {
  return _UpdatePassword.fromJson(json);
}

/// @nodoc
mixin _$UpdatePassword {
  @JsonKey(name: 'old_password')
  String get oldPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_password')
  String get newPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_password_again')
  String get newPasswordAgain => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdatePasswordCopyWith<UpdatePassword> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdatePasswordCopyWith<$Res> {
  factory $UpdatePasswordCopyWith(
          UpdatePassword value, $Res Function(UpdatePassword) then) =
      _$UpdatePasswordCopyWithImpl<$Res, UpdatePassword>;
  @useResult
  $Res call(
      {@JsonKey(name: 'old_password') String oldPassword,
      @JsonKey(name: 'new_password') String newPassword,
      @JsonKey(name: 'new_password_again') String newPasswordAgain});
}

/// @nodoc
class _$UpdatePasswordCopyWithImpl<$Res, $Val extends UpdatePassword>
    implements $UpdatePasswordCopyWith<$Res> {
  _$UpdatePasswordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldPassword = null,
    Object? newPassword = null,
    Object? newPasswordAgain = null,
  }) {
    return _then(_value.copyWith(
      oldPassword: null == oldPassword
          ? _value.oldPassword
          : oldPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPasswordAgain: null == newPasswordAgain
          ? _value.newPasswordAgain
          : newPasswordAgain // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdatePasswordImplCopyWith<$Res>
    implements $UpdatePasswordCopyWith<$Res> {
  factory _$$UpdatePasswordImplCopyWith(_$UpdatePasswordImpl value,
          $Res Function(_$UpdatePasswordImpl) then) =
      __$$UpdatePasswordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'old_password') String oldPassword,
      @JsonKey(name: 'new_password') String newPassword,
      @JsonKey(name: 'new_password_again') String newPasswordAgain});
}

/// @nodoc
class __$$UpdatePasswordImplCopyWithImpl<$Res>
    extends _$UpdatePasswordCopyWithImpl<$Res, _$UpdatePasswordImpl>
    implements _$$UpdatePasswordImplCopyWith<$Res> {
  __$$UpdatePasswordImplCopyWithImpl(
      _$UpdatePasswordImpl _value, $Res Function(_$UpdatePasswordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldPassword = null,
    Object? newPassword = null,
    Object? newPasswordAgain = null,
  }) {
    return _then(_$UpdatePasswordImpl(
      oldPassword: null == oldPassword
          ? _value.oldPassword
          : oldPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPasswordAgain: null == newPasswordAgain
          ? _value.newPasswordAgain
          : newPasswordAgain // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdatePasswordImpl implements _UpdatePassword {
  const _$UpdatePasswordImpl(
      {@JsonKey(name: 'old_password') required this.oldPassword,
      @JsonKey(name: 'new_password') required this.newPassword,
      @JsonKey(name: 'new_password_again') required this.newPasswordAgain});

  factory _$UpdatePasswordImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatePasswordImplFromJson(json);

  @override
  @JsonKey(name: 'old_password')
  final String oldPassword;
  @override
  @JsonKey(name: 'new_password')
  final String newPassword;
  @override
  @JsonKey(name: 'new_password_again')
  final String newPasswordAgain;

  @override
  String toString() {
    return 'UpdatePassword(oldPassword: $oldPassword, newPassword: $newPassword, newPasswordAgain: $newPasswordAgain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdatePasswordImpl &&
            (identical(other.oldPassword, oldPassword) ||
                other.oldPassword == oldPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword) &&
            (identical(other.newPasswordAgain, newPasswordAgain) ||
                other.newPasswordAgain == newPasswordAgain));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, oldPassword, newPassword, newPasswordAgain);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdatePasswordImplCopyWith<_$UpdatePasswordImpl> get copyWith =>
      __$$UpdatePasswordImplCopyWithImpl<_$UpdatePasswordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatePasswordImplToJson(
      this,
    );
  }
}

abstract class _UpdatePassword implements UpdatePassword {
  const factory _UpdatePassword(
      {@JsonKey(name: 'old_password') required final String oldPassword,
      @JsonKey(name: 'new_password') required final String newPassword,
      @JsonKey(name: 'new_password_again')
      required final String newPasswordAgain}) = _$UpdatePasswordImpl;

  factory _UpdatePassword.fromJson(Map<String, dynamic> json) =
      _$UpdatePasswordImpl.fromJson;

  @override
  @JsonKey(name: 'old_password')
  String get oldPassword;
  @override
  @JsonKey(name: 'new_password')
  String get newPassword;
  @override
  @JsonKey(name: 'new_password_again')
  String get newPasswordAgain;
  @override
  @JsonKey(ignore: true)
  _$$UpdatePasswordImplCopyWith<_$UpdatePasswordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
