/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/types/json_map.dart';
import '../../shared/utils/dates.dart';

part 'event_form_data.freezed.dart';
part 'event_form_data.g.dart';

@freezed
class EventFormData with _$EventFormData {
  const EventFormData._();

  const factory EventFormData({
    required String name,
    required String? description,
    @JsonKey(toJson: dateToJson, name: "start_date")
    required DateTime startDate,
    @JsonKey(toJson: dateToJson, name: "end_date") required DateTime? endDate,
    int? budget,
  }) = _EventFormData;

  EventFormData withBudget(int? budget) => EventFormData(
        name: name,
        description: description,
        startDate: startDate,
        endDate: endDate,
        budget: budget,
      );

  factory EventFormData.fromJson(JsonMap json) => _$EventFormDataFromJson(json);
}
