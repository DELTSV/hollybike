import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../user/types/minimal_user.dart';
import 'event_status_state.dart';

part 'event.g.dart';

@immutable
@JsonSerializable()
class Event extends MinimalEvent {
  const Event({
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

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
