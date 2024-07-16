/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImageImpl _$$EventImageImplFromJson(Map<String, dynamic> json) =>
    _$EventImageImpl(
      id: (json['id'] as num).toInt(),
      key: json['key'] as String,
      url: json['url'] as String,
      size: (json['size'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
    );

Map<String, dynamic> _$$EventImageImplToJson(_$EventImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'url': instance.url,
      'size': instance.size,
      'width': instance.width,
      'height': instance.height,
    };
