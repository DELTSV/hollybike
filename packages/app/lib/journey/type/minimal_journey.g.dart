// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minimal_journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MinimalJourneyImpl _$$MinimalJourneyImplFromJson(Map<String, dynamic> json) =>
    _$MinimalJourneyImpl(
      id: (json['id'] as num).toInt(),
      file: json['file'] as String?,
      start: json['start'] == null
          ? null
          : Position.fromJson(json['start'] as Map<String, dynamic>),
      end: json['end'] == null
          ? null
          : Position.fromJson(json['end'] as Map<String, dynamic>),
      destination: json['destination'] == null
          ? null
          : Position.fromJson(json['destination'] as Map<String, dynamic>),
      previewImage: json['preview_image'] as String?,
    );

Map<String, dynamic> _$$MinimalJourneyImplToJson(
        _$MinimalJourneyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file': instance.file,
      'start': instance.start,
      'end': instance.end,
      'destination': instance.destination,
      'preview_image': instance.previewImage,
    };
