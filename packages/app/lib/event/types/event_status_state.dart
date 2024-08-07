/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:json_annotation/json_annotation.dart';

enum EventStatusState {
  @JsonValue('Pending')
  pending,
  @JsonValue('Scheduled')
  scheduled,
  @JsonValue('Cancelled')
  canceled,
  @JsonValue('Finished')
  finished,
  @JsonValue('Now')
  now,
}
