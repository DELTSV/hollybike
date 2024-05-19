import 'package:freezed_annotation/freezed_annotation.dart';

enum UserScope {
  @JsonValue('Root')
  root,
  @JsonValue('Admin')
  admin,
  @JsonValue('User')
  user,
}