// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_removed_from_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketRemovedFromEventImpl _$$WebsocketRemovedFromEventImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketRemovedFromEventImpl(
      type: json['type'] as String? ?? "RemovedFromEventNotification",
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$WebsocketRemovedFromEventImplToJson(
        _$WebsocketRemovedFromEventImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'name': instance.name,
    };
