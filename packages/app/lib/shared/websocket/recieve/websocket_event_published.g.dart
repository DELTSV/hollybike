// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_event_published.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketEventPublishedImpl _$$WebsocketEventPublishedImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketEventPublishedImpl(
      type: json['type'] as String? ?? "NewEventNotification",
      notificationId: (json['notification_id'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      image: json['image'] as String?,
      ownerId: (json['owner_id'] as num).toInt(),
      ownerName: json['owner_name'] as String,
    );

Map<String, dynamic> _$$WebsocketEventPublishedImplToJson(
        _$WebsocketEventPublishedImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'notification_id': instance.notificationId,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'image': instance.image,
      'owner_id': instance.ownerId,
      'owner_name': instance.ownerName,
    };
