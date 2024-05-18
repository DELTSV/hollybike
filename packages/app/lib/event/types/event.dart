import 'dart:convert';
import 'dart:typed_data';

import 'package:hollybike/user/types/minimal_user.dart';

enum EventStatusState {
  pending,
  scheduled,
  canceled,
  finished,
}

class Event {
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

  const Event({
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

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
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

  factory Event.fromResponseJson(Uint8List response) {
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

    return Event.fromJson(object);
  }
}
