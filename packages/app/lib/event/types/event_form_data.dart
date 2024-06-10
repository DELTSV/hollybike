import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/types/json_map.dart';
import '../../shared/utils/dates.dart';

part 'event_form_data.freezed.dart';
part 'event_form_data.g.dart';

@freezed
class EventFormData with _$EventFormData {
  const factory EventFormData({
    required String name,
    String? description,
    @JsonKey(toJson: dateToJson, name: "start_date") required DateTime startDate,
    @JsonKey(toJson: dateToJson, name: "end_date") DateTime? endDate,
  }) = _EventFormData;

  factory EventFormData.fromJson(JsonMap json) => _$EventFormDataFromJson(json);
}