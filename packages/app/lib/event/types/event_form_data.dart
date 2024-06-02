import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_form_data.freezed.dart';

@freezed
class EventFormData with _$EventFormData {
  const factory EventFormData({
    required String name,
    required String? description,
    required DateTime startDate,
    required DateTime? endDate,
  }) = _EventFormData;
}