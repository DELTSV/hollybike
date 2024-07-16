/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_map.dart';

part 'position.freezed.dart';
part 'position.g.dart';

enum PositionType {
  restaurant,
  fastFood,
  trainStation,
  airport,
  school,
  motorway,
  skiStation,
  unknown,
}

@freezed
class Position with _$Position {
  const Position._();

  const factory Position({
    required double latitude,
    required double longitude,
    required double? altitude,
    @JsonKey(name: "place_name") required String? placeName,
    @JsonKey(name: "place_type") required String placeType,
    @JsonKey(name: "city_name") required String? cityName,
    @JsonKey(name: "country_name") required String? countryName,
    @JsonKey(name: "county_name") required String? countyName,
    @JsonKey(name: "state_name") required String? stateName,
  }) = _Position;

  factory Position.fromJson(JsonMap json) => _$PositionFromJson(json);

  PositionType get positionType {
    switch (placeType) {
      case "fast_food":
        return PositionType.fastFood;
      case "restaurant":
        return PositionType.restaurant;
      case "train_station":
        return PositionType.trainStation;
      case "airport":
        return PositionType.airport;
      case "university":
      case "college":
      case "school":
        return PositionType.school;
      case "motorway":
        return PositionType.motorway;
      case "station":
        return PositionType.skiStation;
      default:
        return PositionType.unknown;
    }
  }

  static getIcon(PositionType positionType) {
    switch (positionType) {
      case PositionType.restaurant:
        return Icons.restaurant_rounded;
      case PositionType.fastFood:
        return Icons.fastfood_rounded;
      case PositionType.trainStation:
        return Icons.train_rounded;
      case PositionType.airport:
        return Icons.airplanemode_active_rounded;
      case PositionType.school:
        return Icons.school_rounded;
      case PositionType.motorway:
        return Icons.directions_car_rounded;
      case PositionType.skiStation:
        return Icons.downhill_skiing_rounded;
      case PositionType.unknown:
        return Icons.location_on_rounded;
    }
  }
}
