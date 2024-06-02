// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_form_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventFormDataImpl _$$EventFormDataImplFromJson(Map<String, dynamic> json) =>
    _$EventFormDataImpl(
      name: json['name'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$$EventFormDataImplToJson(_$EventFormDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'startDate': _toJson(instance.startDate),
      'endDate': _toJson(instance.endDate),
    };
