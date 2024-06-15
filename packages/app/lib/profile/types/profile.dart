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
    final object = jsonDecode(utf8.decode(response));
    verifyObjectAttributeNotNull(String attribute) {
      if (object[attribute] == null) {
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
    ].forEach(verifyObjectAttributeNotNull);

    return Profile(
      id: object["id"],
      email: object["email"],
      username: object["username"],
      scope: object["scope"],
      status: object["status"],
      lastLogin: DateTime.parse(object["last_login"]),
      association: Association.fromJsonObject(object["association"]),
      profilePicture: object["profile_picture"],
    );
  }
}
