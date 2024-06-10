// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImageMetadataImpl _$$ImageMetadataImplFromJson(Map<String, dynamic> json) =>
    _$ImageMetadataImpl(
      takenDateTime: json['taken_date_time'] == null
          ? null
          : DateTime.parse(json['taken_date_time'] as String),
      position: json['position'] == null
          ? null
          : ImagePositionMetadata.fromJson(
              json['position'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ImageMetadataImplToJson(_$ImageMetadataImpl instance) =>
    <String, dynamic>{
      'taken_date_time': dateToJson(instance.takenDateTime),
      'position': instance.position,
    };
