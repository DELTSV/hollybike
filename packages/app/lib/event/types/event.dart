import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hollybike/event/types/minimal_event.dart';

import '../../shared/types/json_map.dart';
import '../../user/types/minimal_user.dart';
import 'event_status_state.dart';

part 'event.freezed.dart';

part 'event.g.dart';

@freezed
class Event with _$Event {
  const Event._();

  const factory Event({
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

  get color => getStatusColor(status);

  factory Event.fromJson(JsonMap json) => _$EventFromJson(json);

  ImageProvider get imageProvider => imageProviderFromDateTimeAndImage(
        startDate,
        image: image,
      );

  MinimalEvent toMinimalEvent() {
    return MinimalEvent(
      id: id,
      name: name,
      owner: owner,
      status: status,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      image: image,
    );
  }

  static Color getStatusColor(EventStatusState status) {
    switch (status) {
      case EventStatusState.canceled:
        return const Color(0xFFE57373);
      case EventStatusState.pending:
        return const Color(0xFF64B5F6);
      case EventStatusState.now:
        return const Color(0xff94e2d5);
      case EventStatusState.finished:
        return const Color(0xFFB0BEC5);
      case EventStatusState.scheduled:
        return const Color(0xFF81C784);
    }
  }

  static String placeholderImageFromDateTime(DateTime startDate) {
    if (startDate.month >= 3 && startDate.month <= 5) {
      return "assets/images/placeholder_event_image_spring.jpg";
    } else if (startDate.month >= 6 && startDate.month <= 8) {
      return "assets/images/placeholder_event_image_summer.jpg";
    } else if (startDate.month >= 9 && startDate.month <= 11) {
      return "assets/images/placeholder_event_image_autumn.jpg";
    } else {
      return "assets/images/placeholder_event_image_winter.jpg";
    }
  }

  static ImageProvider imageProviderFromDateTimeAndImage(DateTime startDate,
      {String? image}) {
    if (image != null) {
      return CachedNetworkImageProvider(image);
    }

    return AssetImage(placeholderImageFromDateTime(startDate));
  }
}
