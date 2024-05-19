// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minimal_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MinimalUser _$MinimalUserFromJson(Map<String, dynamic> json) => MinimalUser(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      scope: json['scope'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$MinimalUserToJson(MinimalUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'scope': instance.scope,
      'status': instance.status,
    };
