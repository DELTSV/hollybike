import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/event/types/event_role.dart';

import '../../shared/types/json_map.dart';
import '../../user/types/minimal_user.dart';

part 'event_participation.freezed.dart';
part 'event_participation.g.dart';

@freezed
class EventParticipation with _$EventParticipation {
  const factory EventParticipation({
    required MinimalUser user,
    required bool isImagesPublic,
    required EventRole role,
    required DateTime joinedDateTime,
  }) = _EventParticipation;

  factory EventParticipation.fromJson(JsonMap json) => _$EventParticipationFromJson(json);
}