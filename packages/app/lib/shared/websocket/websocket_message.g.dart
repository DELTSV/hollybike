/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketMessageImpl<T>
    _$$WebsocketMessageImplFromJson<T extends WebsocketBody>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
        _$WebsocketMessageImpl<T>(
          channel: json['channel'] as String,
          data: fromJsonT(json['data']),
        );

Map<String, dynamic> _$$WebsocketMessageImplToJson<T extends WebsocketBody>(
  _$WebsocketMessageImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'channel': instance.channel,
      'data': toJsonT(instance.data),
    };
