/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_added_to_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketAddedToEventImpl _$$WebsocketAddedToEventImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketAddedToEventImpl(
      type: json['type'] as String? ?? "AddedToEventNotification",
      notificationId: (json['notification_id'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$WebsocketAddedToEventImplToJson(
        _$WebsocketAddedToEventImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'notification_id': instance.notificationId,
      'id': instance.id,
      'name': instance.name,
    };
