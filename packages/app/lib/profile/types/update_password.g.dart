// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdatePasswordImpl _$$UpdatePasswordImplFromJson(Map<String, dynamic> json) =>
    _$UpdatePasswordImpl(
      oldPassword: json['oldPassword'] as String,
      newPassword: json['newPassword'] as String,
      newPasswordAgain: json['newPasswordAgain'] as String,
    );

Map<String, dynamic> _$$UpdatePasswordImplToJson(
        _$UpdatePasswordImpl instance) =>
    <String, dynamic>{
      'oldPassword': instance.oldPassword,
      'newPassword': instance.newPassword,
      'newPasswordAgain': instance.newPasswordAgain,
    };
