/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventCandidateImpl _$$EventCandidateImplFromJson(Map<String, dynamic> json) =>
    _$EventCandidateImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      isOwner: json['is_owner'] as bool,
      profilePicture: json['profile_picture'] as String?,
      profilePictureKey: json['profile_picture_key'] as String?,
      eventRole: $enumDecodeNullable(_$EventRoleEnumMap, json['event_role']),
    );

Map<String, dynamic> _$$EventCandidateImplToJson(
        _$EventCandidateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'is_owner': instance.isOwner,
      'profile_picture': instance.profilePicture,
      'profile_picture_key': instance.profilePictureKey,
      'event_role': _$EventRoleEnumMap[instance.eventRole],
    };

const _$EventRoleEnumMap = {
  EventRole.organizer: 'Organizer',
  EventRole.member: 'Member',
};
