// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebsocketErrorImpl _$$WebsocketErrorImplFromJson(Map<String, dynamic> json) =>
    _$WebsocketErrorImpl(
      message: json['message'] as String,
      type: json['type'] as String? ?? "subscribed",
    );

Map<String, dynamic> _$$WebsocketErrorImplToJson(
        _$WebsocketErrorImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'type': instance.type,
    };
