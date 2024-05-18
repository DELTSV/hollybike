import 'dart:convert';
import 'dart:typed_data';

import '../../user/types/minimal_user.dart';
import 'event_status_state.dart';

class MinimalEvent {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final MinimalUser owner;
  final EventStatusState status;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  static fromStringStatus(String status) {
    switch (status) {
      case "PENDING":
        return EventStatusState.pending;
      case "SCHEDULED":
        return EventStatusState.scheduled;
      case "CANCELED":
        return EventStatusState.canceled;
      case "FINISHED":
        return EventStatusState.finished;
      default:
        throw const FormatException("Invalid status string");
    }
  }

  const MinimalEvent({
    required this.id,
    required this.name,
    required this.status,
    required this.owner,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.image,
  });

  factory MinimalEvent.fromJson(Map<String, dynamic> json) {
    return MinimalEvent(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      owner: MinimalUser.fromJson(json['owner']),
      status: fromStringStatus(json['status']),
      startDate: DateTime.parse(json['start_date_time']),
      endDate: DateTime.parse(json['end_date_time']),
      createdAt: DateTime.parse(json['create_date_time']),
      updatedAt: DateTime.parse(json['update_date_time']),
    );
  }

  factory MinimalEvent.fromResponseJson(Uint8List response) {
    final object = jsonDecode(utf8.decode(response));
    verifyObjectAttributeNotNull(String attribute) {
      if (object[attribute] == null) {
        throw FormatException("Missing $attribute inside server response");
      }
    }

    [
      "id",
      "name",
      "owner",
      "status",
      "start_date_time",
      "create_date_time",
      "update_date_time",
    ].forEach(verifyObjectAttributeNotNull);

    return MinimalEvent.fromJson(object);
  }

  String get placeholderImage {
    // Choose the image depending on the season of the start date
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
