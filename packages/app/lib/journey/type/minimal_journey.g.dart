// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minimal_journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MinimalJourneyImpl _$$MinimalJourneyImplFromJson(Map<String, dynamic> json) =>
    _$MinimalJourneyImpl(
      file: json['file'] as String?,
      start: json['start'] == null
          ? null
          : Position.fromJson(json['start'] as Map<String, dynamic>),
      end: json['end'] == null
          ? null
          : Position.fromJson(json['end'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MinimalJourneyImplToJson(
        _$MinimalJourneyImpl instance) =>
    <String, dynamic>{
      'file': instance.file,
      'start': instance.start,
      'end': instance.end,
    };
