
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/types/json_map.dart';

part 'event_image.freezed.dart';
part 'event_image.g.dart';

@freezed
class EventImage with _$EventImage {
  const factory EventImage({
    required int id,
    required String url,
    required int size,
    required int width,
    required int height,
  }) = _EventImage;

  factory EventImage.fromJson(JsonMap json) => _$EventImageFromJson(json);
}