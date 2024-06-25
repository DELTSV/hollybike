// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_send_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketSendPositionImpl _$$WebsocketSendPositionImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketSendPositionImpl(
      type: json['type'] as String? ?? "send-user-position",
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      time: DateTime.parse(json['time'] as String),
      speed: (json['speed'] as num).toDouble(),
    );

Map<String, dynamic> _$$WebsocketSendPositionImplToJson(
        _$WebsocketSendPositionImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'time': instance.time.toIso8601String(),
      'speed': instance.speed,
    };
