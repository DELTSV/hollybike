/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:freezed_annotation/freezed_annotation.dart';

enum UserScope {
  @JsonValue('Root')
  root,
  @JsonValue('Admin')
  admin,
  @JsonValue('User')
  user,
}

class UserScopeMapper {
  static UserScope fromString(String value) {
    switch (value) {
      case "Root":
        return UserScope.root;
      case "Admin":
        return UserScope.admin;
      case "User":
        return UserScope.user;
    }
    throw Exception("string value $value has no equivalence in type UserScope");
  }
}
