import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../user/types/minimal_user.dart';
import 'event_status_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'minimal_event.g.dart';

@immutable
@JsonSerializable()
class MinimalEvent {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final MinimalUser owner;
  final EventStatusState status;

  @JsonKey(name: "start_date_time")
  final DateTime startDate;

  @JsonKey(name: "end_date_time")
  final DateTime? endDate;

  @JsonKey(name: "create_date_time")
  final DateTime createdAt;

  @JsonKey(name: "update_date_time")
  final DateTime updatedAt;

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

  factory MinimalEvent.fromJson(Map<String, dynamic> json) => _$MinimalEventFromJson(json);
  static MinimalEvent fromJsonModel(Object? json) => MinimalEvent.fromJson(json as Map<String,dynamic>);

  Map<String, dynamic> toJson() => _$MinimalEventToJson(this);

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
