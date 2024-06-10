import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/types/json_map.dart';

part 'image_position_metadata.freezed.dart';
part 'image_position_metadata.g.dart';

@freezed
class ImagePositionMetadata with _$ImagePositionMetadata {
  const factory ImagePositionMetadata({
    required double latitude,
    required double longitude,
    int? altitude,
  }) = _ImagePositionMetadata;

  factory ImagePositionMetadata.fromJson(JsonMap json) => _$ImagePositionMetadataFromJson(json);
}