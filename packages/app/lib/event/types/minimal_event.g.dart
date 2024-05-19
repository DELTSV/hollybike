// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minimal_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MinimalEvent _$MinimalEventFromJson(Map<String, dynamic> json) => MinimalEvent(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      status: $enumDecode(_$EventStatusStateEnumMap, json['status']),
      owner: MinimalUser.fromJson(json['owner'] as Map<String, dynamic>),
      startDate: DateTime.parse(json['start_date_time'] as String),
      endDate: json['end_date_time'] == null
          ? null
          : DateTime.parse(json['end_date_time'] as String),
      createdAt: DateTime.parse(json['create_date_time'] as String),
      updatedAt: DateTime.parse(json['update_date_time'] as String),
      description: json['description'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$MinimalEventToJson(MinimalEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'owner': instance.owner,
      'status': _$EventStatusStateEnumMap[instance.status]!,
      'start_date_time': instance.startDate.toIso8601String(),
      'end_date_time': instance.endDate?.toIso8601String(),
      'create_date_time': instance.createdAt.toIso8601String(),
      'update_date_time': instance.updatedAt.toIso8601String(),
    };

const _$EventStatusStateEnumMap = {
  EventStatusState.pending: 'PENDING',
  EventStatusState.scheduled: 'SCHEDULED',
  EventStatusState.canceled: 'CANCELED',
  EventStatusState.finished: 'FINISHED',
};
