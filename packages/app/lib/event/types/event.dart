import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/types/json_map.dart';
import '../../user/types/minimal_user.dart';
import 'event_status_state.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class Event with _$Event {
  const Event._();

  const factory Event.a({
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
  }) = _Event;

  factory Event.fromJson(JsonMap json) => _$EventFromJson(json);

  factory Event.fromResponseJson(
    Uint8List response,
  ) {
    return Event.fromJson(jsonDecode(utf8.decode(response)));
  }

  String get placeholderImage => placeholderImageFromDateTime(startDate);

  static String placeholderImageFromDateTime(DateTime startDate) {
    if (startDate.month >= 3 && startDate.month <= 5) {
      return "images/placeholder_event_image_spring.jpg";
    } else if (startDate.month >= 6 && startDate.month <= 8) {
      return "images/placeholder_event_image_summer.jpg";
    } else if (startDate.month >= 9 && startDate.month <= 11) {
      return "images/placeholder_event_image_autumn.jpg";
    } else {
      return "images/placeholder_event_image_winter.jpg";
    }
  }
}
