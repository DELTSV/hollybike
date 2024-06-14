import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_map.dart';

part 'position.freezed.dart';
part 'position.g.dart';


@freezed
class Position with _$Position {
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
}
