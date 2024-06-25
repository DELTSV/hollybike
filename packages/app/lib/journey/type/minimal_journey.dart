import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/position.dart';

import '../../shared/types/json_map.dart';

part 'minimal_journey.freezed.dart';
part 'minimal_journey.g.dart';

@freezed
class MinimalJourney with _$MinimalJourney {
  const MinimalJourney._();

  const factory MinimalJourney({
    required int id,
    required String? file,
    required Position? start,
    required Position? end,
    required Position? destination,
    required int? totalDistance,
    required int? minElevation,
    required int? maxElevation,
    required int? totalElevationGain,
    required int? totalElevationLoss,
    @JsonKey(name: 'preview_image') String? previewImage,
  }) = _MinimalJourney;

  factory MinimalJourney.fromJson(JsonMap json) => _$MinimalJourneyFromJson(json);

  static String getDistanceLabel(int? totalDistance) {
    if (totalDistance == null) {
      return '';
    }

    final totalDistanceInMeters = totalDistance;

    if (totalDistanceInMeters < 1000) {
      return '$totalDistanceInMeters m';
    } else {
      return '${totalDistanceInMeters ~/ 1000} km';
    }
  }

  get distanceLabel {
    return getDistanceLabel(totalDistance);
  }

  String? get readablePartialLocation {
    if (destination == null) {
      return null;
    }

    final cityName = destination!.cityName;
    final countyName = destination!.countyName;
    final stateName = destination!.stateName;
    final countryName = destination!.countryName;

    final texts = <String>[];

    final name = countyName ?? stateName ?? cityName;

    if (name != null) {
      texts.add(name);
    }

    if (countryName != null && countryName != "France") {
      texts.add(countryName);
    }

    if (texts.isEmpty) {
      return null;
    }

    return texts.join(", ");
  }

  get haveAllPositions => start != null && end != null && destination != null;
}