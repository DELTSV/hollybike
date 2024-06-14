// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_image_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImageDetailsImpl _$$EventImageDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$EventImageDetailsImpl(
      isOwner: json['isOwner'] as bool,
      owner: MinimalUser.fromJson(json['owner'] as Map<String, dynamic>),
      event: MinimalEvent.fromJson(json['event'] as Map<String, dynamic>),
      position: json['position'] == null
          ? null
          : Position.fromJson(json['position'] as Map<String, dynamic>),
      takenDateTime: json['taken_date_time'] == null
          ? null
          : DateTime.parse(json['taken_date_time'] as String),
      uploadDateTime: DateTime.parse(json['uploaded_date_time'] as String),
    );

Map<String, dynamic> _$$EventImageDetailsImplToJson(
        _$EventImageDetailsImpl instance) =>
    <String, dynamic>{
      'isOwner': instance.isOwner,
      'owner': instance.owner,
      'event': instance.event,
      'position': instance.position,
      'taken_date_time': instance.takenDateTime?.toIso8601String(),
      'uploaded_date_time': instance.uploadDateTime.toIso8601String(),
    };
