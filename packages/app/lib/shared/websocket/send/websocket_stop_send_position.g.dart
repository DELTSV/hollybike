/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_stop_send_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketStopSendPositionImpl _$$WebsocketStopSendPositionImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketStopSendPositionImpl(
      type: json['type'] as String? ?? "stop-send-user-position",
    );

Map<String, dynamic> _$$WebsocketStopSendPositionImplToJson(
        _$WebsocketStopSendPositionImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
    };
