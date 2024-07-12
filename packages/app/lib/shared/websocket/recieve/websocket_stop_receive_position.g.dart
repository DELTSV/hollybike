// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_stop_receive_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketStopReceivePositionImpl _$$WebsocketStopReceivePositionImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketStopReceivePositionImpl(
      type: json['type'] as String,
      userId: (json['user'] as num).toInt(),
    );

Map<String, dynamic> _$$WebsocketStopReceivePositionImplToJson(
        _$WebsocketStopReceivePositionImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'user': instance.userId,
    };
