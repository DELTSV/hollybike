/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/types/participation/event_caller_participation.dart';
import 'package:hollybike/event/types/participation/event_participation.dart';
import 'package:hollybike/event/types/participation/event_role.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';

import '../../shared/types/json_map.dart';
import 'event_expense.dart';

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
    required List<EventExpense>? expenses,
    required int? totalExpense,
  }) = _EventDetails;

  factory EventDetails.fromJson(JsonMap json) => _$EventDetailsFromJson(json);

  factory EventDetails.empty() => EventDetails(
        event: Event.empty(),
        journey: null,
        expenses: null,
        callerParticipation: null,
        previewParticipants: [],
        previewParticipantsCount: 0,
        totalExpense: null,
      );

  bool get isOwner =>
      callerParticipation != null &&
      callerParticipation!.userId == event.owner.id;

  bool get isParticipating => callerParticipation != null;

  bool get canJoin =>
      !isParticipating && event.status == EventStatusState.scheduled ||
      event.status == EventStatusState.now;

  bool get isOrganizer =>
      callerParticipation != null &&
      callerParticipation!.role == EventRole.organizer;

  bool get canEditJourney {
    return isOrganizer &&
        (event.status != EventStatusState.finished &&
            event.status != EventStatusState.canceled);
  }
}
