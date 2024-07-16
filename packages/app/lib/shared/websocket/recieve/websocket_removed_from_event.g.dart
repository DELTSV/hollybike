/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_removed_from_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketRemovedFromEventImpl _$$WebsocketRemovedFromEventImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketRemovedFromEventImpl(
      type: json['type'] as String? ?? "RemovedFromEventNotification",
      notificationId: (json['notification_id'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$WebsocketRemovedFromEventImplToJson(
        _$WebsocketRemovedFromEventImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'notification_id': instance.notificationId,
      'id': instance.id,
      'name': instance.name,
    };
