import 'dart:convert';

import 'package:hollybike/association/types/association.dart';
import 'package:hollybike/shared/utils/verify_object_attributes_not_null.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:hollybike/user/types/user_scope.dart';
import 'package:hollybike/user/types/user_status.dart';

class Profile {
  final int id;
  final String email;
  final String username;
  final UserScope scope;
  final UserStatus status;
  final DateTime lastLogin;
  final Association association;
  final String? profilePicture;
  final String? profilePictureKey;
  final String? role;

  const Profile({
    required this.id,
    required this.email,
    required this.username,
    required this.scope,
    required this.status,
    required this.lastLogin,
    required this.association,
    this.profilePicture,
    this.profilePictureKey,
    this.role,
  });

  MinimalUser toMinimalUser() => MinimalUser(
        id: id,
        username: username,
        scope: scope,
        status: status,
        profilePicture: profilePicture,
        role: role,
      );

  static Profile fromResponseJson(List<int> response) {
    final json = jsonDecode(utf8.decode(response));
    return Profile.fromJson(json);
  }

  withProfilePicture(String profilePicture) => Profile(
        id: id,
        email: email,
        username: username,
        scope: scope,
        status: status,
        lastLogin: lastLogin,
        association: association,
        profilePicture: profilePicture,
      );

  factory Profile.fromJson(Map<String, dynamic> json) {
    verifyObjectAttributesNotNull(
      json,
      [
        "id",
        "email",
        "username",
        "scope",
        "status",
        "last_login",
        "association",
      ],
    );
    return Profile(
      id: json["id"],
      email: json["email"],
      username: json["username"],
      scope: UserScopeMapper.fromString(json["scope"]),
      status: UserStatusMapper.fromString(json["status"]),
      lastLogin: DateTime.parse(json["last_login"]),
      association: Association.fromJsonObject(json["association"]),
      profilePicture: json["profile_picture"],
      profilePictureKey: json["profile_picture_key"],
    );
  }
}
