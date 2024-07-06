// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_event_deleted.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketEventDeletedImpl _$$WebsocketEventDeletedImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketEventDeletedImpl(
      type: json['type'] as String? ?? "DeleteEventNotification",
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$WebsocketEventDeletedImplToJson(
        _$WebsocketEventDeletedImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
    };
