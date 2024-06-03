import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/types/event_caller_participation.dart';

import '../../shared/types/json_map.dart';
import 'event_participation.dart';

part 'event_details.freezed.dart';
part 'event_details.g.dart';

@freezed
class EventDetails with _$EventDetails {
  const factory EventDetails({
    required Event event,
    required EventCallerParticipation callerParticipation,
    required List<EventParticipation> previewParticipants,
    required int previewParticipantsCount,
  }) = _EventDetails;

  factory EventDetails.fromJson(JsonMap json) => _$EventDetailsFromJson(json);
}