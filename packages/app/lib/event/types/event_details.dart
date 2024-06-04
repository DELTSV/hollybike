import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/types/event_caller_participation.dart';
import 'package:hollybike/event/types/event_status_state.dart';

import '../../shared/types/json_map.dart';
import 'event_participation.dart';
import 'event_role.dart';

part 'event_details.freezed.dart';

part 'event_details.g.dart';

@freezed
class EventDetails with _$EventDetails {
  const EventDetails._();

  const factory EventDetails({
    required Event event,
    required EventCallerParticipation? callerParticipation,
    required List<EventParticipation> previewParticipants,
    required int previewParticipantsCount,
  }) = _EventDetails;

  factory EventDetails.fromJson(JsonMap json) => _$EventDetailsFromJson(json);

  bool get isOwner =>
      callerParticipation != null &&
      callerParticipation!.userId == event.owner.id;

  bool get isParticipating => callerParticipation != null;

  bool get canJoin =>
      !isParticipating && event.status == EventStatusState.scheduled;

  bool get isOrganizer =>
      callerParticipation != null &&
      callerParticipation!.role == EventRole.organizer;
}
