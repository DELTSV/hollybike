import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/shared/types/json_map.dart';

part 'image_path_dto.freezed.dart';

part 'image_path_dto.g.dart';

@freezed
class ImagePathDto with _$ImagePathDto {
  const factory ImagePathDto({
    required String path,
  }) = _ImagePathDto;

  factory ImagePathDto.fromJson(JsonMap json) => _$ImagePathDtoFromJson(json);
}
