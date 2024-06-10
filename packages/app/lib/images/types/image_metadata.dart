import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/images/types/image_position_metadata.dart';

import '../../shared/types/json_map.dart';
import '../../shared/utils/dates.dart';

part 'image_metadata.freezed.dart';
part 'image_metadata.g.dart';

@freezed
class ImageMetadata with _$ImageMetadata {
  const factory ImageMetadata({
    @JsonKey(toJson: dateToJson, name: "taken_date_time") DateTime? takenDateTime,
    @JsonKey(name: "position") ImagePositionMetadata? position,
  }) = _ImageMetadata;

  factory ImageMetadata.fromJson(JsonMap json) => _$ImageMetadataFromJson(json);
}