import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/position.dart';

import '../../shared/types/json_map.dart';

part 'minimal_journey.freezed.dart';
part 'minimal_journey.g.dart';

@freezed
class MinimalJourney with _$MinimalJourney {
  const factory MinimalJourney({
    required int id,
    required String? file,
    required Position? start,
    required Position? end,
    required Position? destination,
    @JsonKey(name: 'preview_image') String? previewImage,
  }) = _MinimalJourney;

  factory MinimalJourney.fromJson(JsonMap json) => _$MinimalJourneyFromJson(json);
}