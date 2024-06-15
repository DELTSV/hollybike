// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_caller_participation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventCallerParticipationImpl _$$EventCallerParticipationImplFromJson(
        Map<String, dynamic> json) =>
    _$EventCallerParticipationImpl(
      userId: (json['userId'] as num).toInt(),
      isImagesPublic: json['isImagesPublic'] as bool,
      role: $enumDecode(_$EventRoleEnumMap, json['role']),
      joinedDateTime: DateTime.parse(json['joinedDateTime'] as String),
    );

Map<String, dynamic> _$$EventCallerParticipationImplToJson(
        _$EventCallerParticipationImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'isImagesPublic': instance.isImagesPublic,
      'role': _$EventRoleEnumMap[instance.role]!,
      'joinedDateTime': instance.joinedDateTime.toIso8601String(),
    };

const _$EventRoleEnumMap = {
  EventRole.organizer: 'Organizer',
  EventRole.member: 'Member',
};
