import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../shared/types/json_map.dart';

part 'event_form_data.freezed.dart';
part 'event_form_data.g.dart';

@freezed
class EventFormData with _$EventFormData {
  const factory EventFormData({
    required String name,
    String? description,
    @JsonKey(toJson: _toJson) required DateTime startDate,
    @JsonKey(toJson: _toJson) DateTime? endDate,
  }) = _EventFormData;

  factory EventFormData.fromJson(JsonMap json) =>
      _$EventFormDataFromJson(json);
}

String? _toJson(DateTime? dateTime) => dateTime == null
    ? null
    : DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(dateTime);
