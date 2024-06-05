import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/event/types/event_role.dart';

part 'event_candidate.freezed.dart';
part 'event_candidate.g.dart';

@freezed
class EventCandidate with _$EventCandidate {
  const factory EventCandidate({
    required int id,
    required String username,
    @JsonKey(name: "is_owner") required bool isOwner,
    @JsonKey(name: "profile_picture") String? profilePicture,
    @JsonKey(name: "event_role") EventRole? eventRole,
  }) = _EventCandidate;

  factory EventCandidate.fromJson(Map<String, dynamic> json) =>
      _$EventCandidateFromJson(json);
}
