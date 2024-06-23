// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketPositionImpl _$$WebsocketPositionImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketPositionImpl(
      type: json['type'] as String? ?? "send-user-position",
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$$WebsocketPositionImplToJson(
        _$WebsocketPositionImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'time': instance.time.toIso8601String(),
    };
