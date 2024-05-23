import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/event/types/event.dart';

import '../../shared/types/json_map.dart';
import '../../user/types/minimal_user.dart';
import 'event_status_state.dart';

part 'minimal_event.freezed.dart';

part 'minimal_event.g.dart';

@freezed
class MinimalEvent with _$MinimalEvent {
  const MinimalEvent._();

  const factory MinimalEvent({
    required int id,
    required String name,
    required MinimalUser owner,
    required EventStatusState status,
    @JsonKey(name: "start_date_time") required DateTime startDate,
    @JsonKey(name: "end_date_time") DateTime? endDate,
    @JsonKey(name: "create_date_time") required DateTime createdAt,
    @JsonKey(name: "update_date_time") required DateTime updatedAt,
    String? description,
    String? image,
  }) = _MinimalEvent;

  factory MinimalEvent.fromJson(JsonMap json) => _$MinimalEventFromJson(json);

  String get placeholderImage => Event.placeholderImageFromDateTime(startDate);
}
