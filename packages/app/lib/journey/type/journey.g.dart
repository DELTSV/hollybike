// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JourneyImpl _$$JourneyImplFromJson(Map<String, dynamic> json) =>
    _$JourneyImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      file: json['file'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      previewImage: json['preview_image'] as String?,
      previewImageKey: json['preview_image_key'] as String?,
      creator: MinimalUser.fromJson(json['creator'] as Map<String, dynamic>),
      start: json['start'] == null
          ? null
          : Position.fromJson(json['start'] as Map<String, dynamic>),
      end: json['end'] == null
          ? null
          : Position.fromJson(json['end'] as Map<String, dynamic>),
      destination: json['destination'] == null
          ? null
          : Position.fromJson(json['destination'] as Map<String, dynamic>),
      totalDistance: (json['totalDistance'] as num?)?.toInt(),
      minElevation: (json['minElevation'] as num?)?.toInt(),
      maxElevation: (json['maxElevation'] as num?)?.toInt(),
      totalElevationGain: (json['totalElevationGain'] as num?)?.toInt(),
      totalElevationLoss: (json['totalElevationLoss'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$JourneyImplToJson(_$JourneyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file': instance.file,
      'created_at': instance.createdAt.toIso8601String(),
      'preview_image': instance.previewImage,
      'preview_image_key': instance.previewImageKey,
      'creator': instance.creator,
      'start': instance.start,
      'end': instance.end,
      'destination': instance.destination,
      'totalDistance': instance.totalDistance,
      'minElevation': instance.minElevation,
      'maxElevation': instance.maxElevation,
      'totalElevationGain': instance.totalElevationGain,
      'totalElevationLoss': instance.totalElevationLoss,
    };
