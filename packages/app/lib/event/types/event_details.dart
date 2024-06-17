import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/types/participation/event_caller_participation.dart';
import 'package:hollybike/event/types/participation/event_participation.dart';
import 'package:hollybike/event/types/participation/event_role.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';

import '../../shared/types/json_map.dart';

part 'event_details.freezed.dart';

part 'event_details.g.dart';

@freezed
class EventDetails with _$EventDetails {
  const EventDetails._();

  const factory EventDetails({
    required Event event,
    required MinimalJourney? journey,
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
