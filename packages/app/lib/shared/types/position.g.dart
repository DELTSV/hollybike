// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PositionImpl _$$PositionImplFromJson(Map<String, dynamic> json) =>
    _$PositionImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      placeName: json['place_name'] as String?,
      placeType: json['place_type'] as String,
      cityName: json['city_name'] as String?,
      countryName: json['country_name'] as String?,
      countyName: json['county_name'] as String?,
      stateName: json['state_name'] as String?,
    );

Map<String, dynamic> _$$PositionImplToJson(_$PositionImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'place_name': instance.placeName,
      'place_type': instance.placeType,
      'city_name': instance.cityName,
      'country_name': instance.countryName,
      'county_name': instance.countyName,
      'state_name': instance.stateName,
    };
