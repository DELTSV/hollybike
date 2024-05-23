// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateEventDTOImpl _$$CreateEventDTOImplFromJson(Map<String, dynamic> json) =>
    _$CreateEventDTOImpl(
      name: json['name'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$CreateEventDTOImplToJson(
        _$CreateEventDTOImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'startDate': _toJson(instance.startDate),
      'endDate': _toJson(instance.endDate),
      'description': instance.description,
    };
