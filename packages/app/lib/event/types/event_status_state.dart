import 'package:json_annotation/json_annotation.dart';

enum EventStatusState {
  @JsonValue('PENDING')
  pending,
  @JsonValue('SCHEDULED')
  scheduled,
  @JsonValue('CANCELED')
  canceled,
  @JsonValue('FINISHED')
  finished,
}