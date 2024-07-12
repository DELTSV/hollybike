// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_event_deleted.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketEventDeletedImpl _$$WebsocketEventDeletedImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketEventDeletedImpl(
      type: json['type'] as String? ?? "DeleteEventNotification",
      notificationId: (json['notification_id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$WebsocketEventDeletedImplToJson(
        _$WebsocketEventDeletedImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'notification_id': instance.notificationId,
      'name': instance.name,
      'description': instance.description,
    };
