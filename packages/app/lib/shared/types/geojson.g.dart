// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geojson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeoJSONImpl _$$GeoJSONImplFromJson(Map<String, dynamic> json) =>
    _$GeoJSONImpl(
      bbox: (json['bbox'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$$GeoJSONImplToJson(_$GeoJSONImpl instance) =>
    <String, dynamic>{
      'bbox': instance.bbox,
    };
