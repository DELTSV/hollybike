import 'package:freezed_annotation/freezed_annotation.dart';

enum EventRole {
  @JsonValue('Organizer')
  organizer,
  @JsonValue('Member')
  member,
}
