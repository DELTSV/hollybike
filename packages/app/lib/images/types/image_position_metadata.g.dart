// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_position_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImagePositionMetadataImpl _$$ImagePositionMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$ImagePositionMetadataImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ImagePositionMetadataImplToJson(
        _$ImagePositionMetadataImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
    };
