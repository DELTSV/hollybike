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
      heading: (json['heading'] as num).toDouble(),
      accelerationX: (json['acceleration_x'] as num).toDouble(),
      accelerationY: (json['acceleration_y'] as num).toDouble(),
      accelerationZ: (json['acceleration_z'] as num).toDouble(),
      time: DateTime.parse(json['time'] as String),
      speed: (json['speed'] as num).toDouble(),
      speedAccuracy: (json['speed_accuracy'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
    );

Map<String, dynamic> _$$WebsocketSendPositionImplToJson(
        _$WebsocketSendPositionImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'heading': instance.heading,
      'acceleration_x': instance.accelerationX,
      'acceleration_y': instance.accelerationY,
      'acceleration_z': instance.accelerationZ,
      'time': instance.time.toIso8601String(),
      'speed': instance.speed,
      'speed_accuracy': instance.speedAccuracy,
      'accuracy': instance.accuracy,
    };
