import 'dart:convert';

import 'package:hollybike/association/types/association.dart';

class Profile {
  final int id;
  final String email;
  final String username;
  final String scope;
  final String status;
  final DateTime lastLogin;
  final Association association;
  final String? profilePicture;

  const Profile({
    required this.id,
    required this.email,
    required this.username,
    required this.scope,
    required this.status,
    required this.lastLogin,
    required this.association,
    this.profilePicture,
  });

  static Profile fromResponseJson(List<int> response) {
    final json = jsonDecode(utf8.decode(response));
    return Profile.fromJson(json);
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    _verifyObjectAttributeNotNull(json);
    return Profile(
      id: json["id"],
      email: json["email"],
      username: json["username"],
      scope: json["scope"],
      status: json["status"],
      lastLogin: DateTime.parse(json["last_login"]),
      association: Association.fromJsonObject(json["association"]),
      profilePicture: json["profile_picture"],
    );
  }

  static void _verifyObjectAttributeNotNull(Map<String, dynamic> json) {
    verifyAttribute(String attribute) {
      if (json[attribute] == null) {
        throw FormatException("Missing $attribute inside server response");
      }
    }

    [
      "id",
      "email",
      "username",
      "scope",
      "status",
      "last_login",
      "association",
    ].forEach(verifyAttribute);
  }
}
