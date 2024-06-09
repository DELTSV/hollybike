
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/types/json_map.dart';
import '../../user/types/minimal_user.dart';

part 'event_image.freezed.dart';
part 'event_image.g.dart';

@freezed
class EventImage with _$EventImage {
  const factory EventImage({
    required int id,
    required MinimalUser owner,
    required String url,
    required int size,
    @JsonKey(name: "upload_date_time") required DateTime uploadDateTime,
  }) = _EventImage;

  factory EventImage.fromJson(JsonMap json) => _$EventImageFromJson(json);
}