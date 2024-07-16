/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_event_updated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketEventUpdatedImpl _$$WebsocketEventUpdatedImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketEventUpdatedImpl(
      type: json['type'] as String? ?? "UpdateEventNotification",
      notificationId: (json['notification_id'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      start: DateTime.parse(json['start'] as String),
      image: json['image'] as String?,
      ownerId: (json['owner_id'] as num).toInt(),
      ownerName: json['owner_name'] as String,
    );

Map<String, dynamic> _$$WebsocketEventUpdatedImplToJson(
        _$WebsocketEventUpdatedImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'notification_id': instance.notificationId,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'start': instance.start.toIso8601String(),
      'image': instance.image,
      'owner_id': instance.ownerId,
      'owner_name': instance.ownerName,
    };
