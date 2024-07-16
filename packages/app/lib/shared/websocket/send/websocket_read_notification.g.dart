/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_read_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketReadNotificationImpl _$$WebsocketReadNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$WebsocketReadNotificationImpl(
      type: json['type'] as String? ?? "read-notification",
      notificationId: (json['notification'] as num).toInt(),
    );

Map<String, dynamic> _$$WebsocketReadNotificationImplToJson(
        _$WebsocketReadNotificationImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'notification': instance.notificationId,
    };
