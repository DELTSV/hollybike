import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../shared/types/json_map.dart';

part 'create_event.freezed.dart';

part 'create_event.g.dart';

@freezed
class CreateEventDTO with _$CreateEventDTO {
  const factory CreateEventDTO({
    required String name,
    @JsonKey(toJson: _toJson) required DateTime startDate,
    @JsonKey(toJson: _toJson) DateTime? endDate,
    String? description,
  }) = _CreateEventDTO;

  factory CreateEventDTO.fromJson(JsonMap json) =>
      _$CreateEventDTOFromJson(json);
}

String? _toJson(DateTime? dateTime) => dateTime == null
    ? null
    : DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(dateTime);
