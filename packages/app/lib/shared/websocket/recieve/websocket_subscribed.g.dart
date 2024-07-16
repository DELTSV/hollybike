/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_subscribed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketSubscribedImpl _$$WebsocketSubscribedImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketSubscribedImpl(
      subscribed: json['subscribed'] as bool,
      type: json['type'] as String? ?? "subscribed",
    );

Map<String, dynamic> _$$WebsocketSubscribedImplToJson(
        _$WebsocketSubscribedImpl instance) =>
    <String, dynamic>{
      'subscribed': instance.subscribed,
      'type': instance.type,
    };
