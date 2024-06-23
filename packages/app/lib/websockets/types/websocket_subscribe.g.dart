// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_subscribe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketSubscribeImpl _$$WebsocketSubscribeImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketSubscribeImpl(
      token: json['token'] as String,
      type: json['type'] as String? ?? "subscribe",
    );

Map<String, dynamic> _$$WebsocketSubscribeImplToJson(
        _$WebsocketSubscribeImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'type': instance.type,
    };
