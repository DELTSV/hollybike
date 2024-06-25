// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserJourneyImpl _$$UserJourneyImplFromJson(Map<String, dynamic> json) =>
    _$UserJourneyImpl(
      id: (json['id'] as num).toInt(),
      file: json['file'] as String,
      avgSpeed: (json['avg_speed'] as num?)?.toInt(),
      totalDistance: (json['total_distance'] as num?)?.toInt(),
      minElevation: (json['min_elevation'] as num?)?.toInt(),
      maxElevation: (json['max_elevation'] as num?)?.toInt(),
      totalElevationGain: (json['total_elevation_gain'] as num?)?.toInt(),
      totalElevationLoss: (json['total_elevation_loss'] as num?)?.toInt(),
      totalTime: (json['total_time'] as num?)?.toInt(),
      maxSpeed: (json['max_speed'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$UserJourneyImplToJson(_$UserJourneyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file': instance.file,
      'avg_speed': instance.avgSpeed,
      'total_distance': instance.totalDistance,
      'min_elevation': instance.minElevation,
      'max_elevation': instance.maxElevation,
      'total_elevation_gain': instance.totalElevationGain,
      'total_elevation_loss': instance.totalElevationLoss,
      'total_time': instance.totalTime,
      'max_speed': instance.maxSpeed,
    };
