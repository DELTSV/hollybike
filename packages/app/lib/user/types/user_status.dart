import 'package:freezed_annotation/freezed_annotation.dart';

enum UserStatus {
  @JsonValue('Enabled')
  enabled,
  @JsonValue('Disabled')
  disabled,
}
