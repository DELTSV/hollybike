// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImageImpl _$$EventImageImplFromJson(Map<String, dynamic> json) =>
    _$EventImageImpl(
      id: (json['id'] as num).toInt(),
      owner: MinimalUser.fromJson(json['owner'] as Map<String, dynamic>),
      url: json['url'] as String,
      size: (json['size'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      uploadDateTime: DateTime.parse(json['upload_date_time'] as String),
    );

Map<String, dynamic> _$$EventImageImplToJson(_$EventImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'url': instance.url,
      'size': instance.size,
      'width': instance.width,
      'height': instance.height,
      'upload_date_time': instance.uploadDateTime.toIso8601String(),
    };
