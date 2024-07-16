/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';

enum UserStatus {
  @JsonValue('Enabled')
  enabled,
  @JsonValue('Disabled')
  disabled,
}

class UserStatusMapper {
  static UserStatus fromString(String value) {
    switch (value) {
      case "Enabled":
        return UserStatus.enabled;
      case "Disabled":
        return UserStatus.disabled;
    }
    throw Exception(
        "string value $value has no equivalence in type UserStatus");
  }
}
