import 'dart:convert';
import 'dart:typed_data';

import 'package:hollybike/event/types/minimal_event.dart';

class Event extends MinimalEvent {
  Event({
    required super.id,
    required super.name,
    required super.status,
    required super.owner,
    required super.startDate,
    required super.endDate,
    required super.createdAt,
    required super.updatedAt,
    super.description,
    super.image,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    MinimalEvent event = MinimalEvent.fromJson(json);

    return Event(
      id: event.id,
      name: event.name,
      description: event.description,
      image: event.image,
      owner: event.owner,
      status: event.status,
      startDate: event.startDate,
      endDate: event.endDate,
      createdAt: event.createdAt,
      updatedAt: event.updatedAt,
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
