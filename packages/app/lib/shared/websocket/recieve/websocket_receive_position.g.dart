/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_receive_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketReceivePositionImpl _$$WebsocketReceivePositionImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketReceivePositionImpl(
      type: json['type'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      time: DateTime.parse(json['time'] as String),
      speed: (json['speed'] as num).toDouble(),
      userId: (json['user'] as num).toInt(),
    );

Map<String, dynamic> _$$WebsocketReceivePositionImplToJson(
        _$WebsocketReceivePositionImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'time': instance.time.toIso8601String(),
      'speed': instance.speed,
      'user': instance.userId,
    };
