/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';

part 'image_path_dto.freezed.dart';

part 'image_path_dto.g.dart';

@freezed
class ImagePathDto with _$ImagePathDto {
  const factory ImagePathDto({
    required String path,
    required String key,
  }) = _ImagePathDto;

  factory ImagePathDto.fromJson(JsonMap json) => _$ImagePathDtoFromJson(json);
}
