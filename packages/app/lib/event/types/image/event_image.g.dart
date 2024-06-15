// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImageImpl _$$EventImageImplFromJson(Map<String, dynamic> json) =>
    _$EventImageImpl(
      id: (json['id'] as num).toInt(),
      url: json['url'] as String,
      size: (json['size'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
    );

Map<String, dynamic> _$$EventImageImplToJson(_$EventImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'size': instance.size,
      'width': instance.width,
      'height': instance.height,
    };
