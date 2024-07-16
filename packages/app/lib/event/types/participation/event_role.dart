/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';

enum EventRole {
  @JsonValue('Organizer')
  organizer,
  @JsonValue('Member')
  member,
}
