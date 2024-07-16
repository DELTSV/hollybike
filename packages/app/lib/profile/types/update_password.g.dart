/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdatePasswordImpl _$$UpdatePasswordImplFromJson(Map<String, dynamic> json) =>
    _$UpdatePasswordImpl(
      oldPassword: json['old_password'] as String,
      newPassword: json['new_password'] as String,
      newPasswordAgain: json['new_password_again'] as String,
    );

Map<String, dynamic> _$$UpdatePasswordImplToJson(
        _$UpdatePasswordImpl instance) =>
    <String, dynamic>{
      'old_password': instance.oldPassword,
      'new_password': instance.newPassword,
      'new_password_again': instance.newPasswordAgain,
    };
