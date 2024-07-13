// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minimal_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MinimalUserImpl _$$MinimalUserImplFromJson(Map<String, dynamic> json) =>
    _$MinimalUserImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      scope: $enumDecode(_$UserScopeEnumMap, json['scope']),
      status: $enumDecode(_$UserStatusEnumMap, json['status']),
      profilePicture: json['profile_picture'] as String?,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$$MinimalUserImplToJson(_$MinimalUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'scope': _$UserScopeEnumMap[instance.scope]!,
      'status': _$UserStatusEnumMap[instance.status]!,
      'profile_picture': instance.profilePicture,
      'role': instance.role,
    };

const _$UserScopeEnumMap = {
  UserScope.root: 'Root',
  UserScope.admin: 'Admin',
  UserScope.user: 'User',
};

const _$UserStatusEnumMap = {
  UserStatus.enabled: 'Enabled',
  UserStatus.disabled: 'Disabled',
};
