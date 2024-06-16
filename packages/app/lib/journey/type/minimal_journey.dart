
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/position.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../../shared/types/json_map.dart';

part 'minimal_journey.freezed.dart';
part 'minimal_journey.g.dart';

@freezed
class MinimalJourney with _$MinimalJourney {
  const factory MinimalJourney({
    required String? file,
    required Position? start,
    required Position? end,
  }) = _MinimalJourney;

  factory MinimalJourney.fromJson(JsonMap json) => _$MinimalJourneyFromJson(json);
}