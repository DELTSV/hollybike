import 'package:flutter/material.dart';
import 'package:hollybike/user/types/user_scope.dart';
import 'package:hollybike/user/types/user_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'minimal_user.g.dart';

@immutable
@JsonSerializable()
class MinimalUser {
  final int id;
  final String username;
  final String scope;
  final String status;

  const MinimalUser({
    required this.id,
    required this.username,
    required this.scope,
    required this.status,
  });

  static UserStatus fromStringStatus(String status) {
    switch (status) {
      case "Enabled":
        return UserStatus.enabled;
      case "Disabled":
        return UserStatus.disabled;
      default:
        throw const FormatException("Invalid status string");
    }
  }

  static UserScope fromStringScope(String scope) {
    switch (scope) {
      case "root":
        return UserScope.root;
      case "admin":
        return UserScope.admin;
      case "user":
        return UserScope.user;
      default:
        throw const FormatException("Invalid scope string");
    }
  }

  factory MinimalUser.fromJson(Map<String, dynamic> json) => _$MinimalUserFromJson(json);

  Map<String, dynamic> toJson() => _$MinimalUserToJson(this);

  // factory MinimalUser.fromJson(Map<String, dynamic> json) {
  //   return MinimalUser(
  //     id: json['id'],
  //     username: json['username'],
  //     scope: json['scope'],
  //     status: json['status'],
  //   );
  // }
}