import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/shared/types/position.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../../../shared/types/json_map.dart';

part 'event_image_details.freezed.dart';
part 'event_image_details.g.dart';


@freezed
class EventImageDetails with _$EventImageDetails {
  const factory EventImageDetails({
    required bool isOwner,
    required MinimalUser owner,
    required MinimalEvent event,
    Position? position,
    @JsonKey(name: "taken_date_time") required DateTime? takenDateTime,
    @JsonKey(name: "uploaded_date_time") required DateTime uploadDateTime,
  }) = _EventImageDetails;

  factory EventImageDetails.fromJson(JsonMap json) => _$EventImageDetailsFromJson(json);
}