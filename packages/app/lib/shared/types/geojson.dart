import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';

part 'geojson.freezed.dart';
part 'geojson.g.dart';

@freezed
class GeoJSON with _$GeoJSON {
  const GeoJSON._();

  const factory GeoJSON({
    required List<double> bbox,
  }) = _GeoJSON;

  factory GeoJSON.fromJson(JsonMap json) => _$GeoJSONFromJson(json);

  factory GeoJSON.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);

    return GeoJSON.fromJson(json);
  }

  List<double> dynamicBBox({List<Coordinate> extraValues = const []}) {
    final baseBbox = _baseBbox();

    final baseCoordinates = [
      Coordinate(
        longitude: baseBbox[0],
        latitude: baseBbox[1],
      ),
      Coordinate(
        longitude: baseBbox[2],
        latitude: baseBbox[3],
      ),
    ];

    final coordinates = baseCoordinates + extraValues;

    return calculateBbox(coordinates);
  }

  static List<double> calculateBbox(
    List<Coordinate> coordinates, {
    double verticalPaddingPercentage = 0.1,
    double horizontalPaddingPercentage = 0.1,
  }) {
    double min(double a, double b) => (a < b) ? a : b;
    double max(double a, double b) => (a > b) ? a : b;

    List<double> bbox = [
      double.infinity,
      double.infinity,
      double.negativeInfinity,
      double.negativeInfinity
    ];

    for (var coordinate in coordinates) {
      bbox[0] = min(bbox[0], coordinate.longitude);
      bbox[1] = min(bbox[1], coordinate.latitude);
      bbox[2] = max(bbox[2], coordinate.longitude);
      bbox[3] = max(bbox[3], coordinate.latitude);
    }

    double width = bbox[2] - bbox[0];
    double height = bbox[3] - bbox[1];

    final realWidth = width <= 0.1 ? 0.1 : width;
    final realHeight = height <= 0.1 ? 0.1 : height;

    double paddingWidth = realWidth * horizontalPaddingPercentage;
    double paddingHeight = realHeight * verticalPaddingPercentage;

    final adjustedHeight =
        realHeight > realWidth ? 0 : (realWidth - realHeight);
    final adjustedWidth =
        realWidth > realHeight ? 0 : (realHeight - realWidth);

    bbox[0] -= (adjustedWidth + paddingWidth);
    bbox[1] -= (adjustedHeight + paddingHeight);
    bbox[2] += (adjustedWidth + paddingWidth);
    bbox[3] += (adjustedHeight + paddingHeight);

    return bbox;
  }

  List<double> _baseBbox() {
    if (bbox.length == 6) {
      return [
        bbox[0],
        bbox[1],
        bbox[3],
        bbox[4],
      ];
    }

    return bbox;
  }
}

class Coordinate {
  final double longitude;
  final double latitude;

  Coordinate({
    required this.longitude,
    required this.latitude,
  });
}
