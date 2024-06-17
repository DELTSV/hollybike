import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/position.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../../shared/types/json_map.dart';
import 'minimal_journey.dart';

part 'journey.freezed.dart';
part 'journey.g.dart';

@freezed
class Journey with _$Journey {
  const Journey._();

  const factory Journey({
    required int id,
    required String name,
    required String? file,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'preview_image') String? previewImage,
    required MinimalUser creator,
    required Position? start,
    required Position? end,
  }) = _Journey;

  MinimalJourney toMinimalJourney() => MinimalJourney(
    id: id,
    file: file,
    previewImage: previewImage,
    start: start,
    end: end,
  );

  factory Journey.fromJson(JsonMap json) => _$JourneyFromJson(json);
}