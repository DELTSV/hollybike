import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/types/json_map.dart';
import 'minimal_journey.dart';

part 'user_journey.freezed.dart';
part 'user_journey.g.dart';


@freezed
class UserJourney with _$UserJourney {
  const UserJourney._();

  const factory UserJourney({
    required int id,
    required String file,
    @JsonKey(name: 'avg_speed') required int? avgSpeed,
    @JsonKey(name: 'total_distance') required int? totalDistance,
    @JsonKey(name: 'min_elevation') required int? minElevation,
    @JsonKey(name: 'max_elevation') required int? maxElevation,
    @JsonKey(name: 'total_elevation_gain') required int? totalElevationGain,
    @JsonKey(name: 'total_elevation_loss') required int? totalElevationLoss,
    @JsonKey(name: 'total_time') required int? totalTime,
    @JsonKey(name: 'max_speed') required int? maxSpeed,
  }) = _UserJourney;

  get distanceLabel {
    return MinimalJourney.getDistanceLabel(totalDistance);
  }

  // the speed is in m/s, convert it to km/h
  get avgSpeedLabel {
    if (avgSpeed == null) {
      return '';
    }
    return '${(avgSpeed! * 3.6).toStringAsFixed(1)} km/h';
  }

  // the speed is in m/s, convert it to km/h
  get maxSpeedLabel {
    if (maxSpeed == null) {
      return '';
    }
    return '${(maxSpeed! * 3.6).toStringAsFixed(1)} km/h';
  }
  // total time in seconds convert it to hours and minutes
  get totalTimeLabel {
    if (totalTime == null) {
      return '';
    }
    final hours = totalTime! ~/ 3600;
    final minutes = (totalTime! % 3600) ~/ 60;

    if (hours == 0) {
      return '$minutes min';
    }

    return '$hours h $minutes min';
  }

  factory UserJourney.fromJson(JsonMap json) => _$UserJourneyFromJson(json);
}