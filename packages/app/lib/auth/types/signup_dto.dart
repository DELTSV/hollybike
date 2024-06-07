import 'dart:convert';

class SignupDto {
  final String verify;
  final String username;
  final String email;
  final String password;
  final String role;
  final int association;
  final int invitation;

  const SignupDto({
    required this.verify,
    required this.username,
    required this.email,
    required this.password,
    required this.association,
    required this.role,
    required this.invitation,
  });

  static SignupDto fromMap(Map<dynamic, dynamic> map) {
    const String verifyKey = "verify";
    const String usernameKey = "username";
    const String emailKey = "email";
    const String passwordKey = "password";
    const String associationKey = "association";
    const String roleKey = "role";
    const String invitationKey = "invitation";

    final missingValues = [
      verifyKey,
      usernameKey,
      emailKey,
      passwordKey,
      associationKey,
      roleKey,
      invitationKey,
    ].where(
      (keyName) => map[keyName] == null,
    );
    if (missingValues.isNotEmpty) {
      const String separator = "\n- ";
      final List<String> prefix = [
        '$map cannot be converted to LoginDto missing values for :',
      ];
      throw FormatException((prefix + missingValues.toList()).join(separator));
    }

    return SignupDto(
      verify: map[verifyKey] as String,
      username: map[usernameKey] as String,
      email: map[emailKey] as String,
      password: map[passwordKey] as String,
      association: int.parse(map[associationKey] as String),
      role: map[roleKey] as String,
      invitation: int.parse(map[invitationKey] as String),
    );
  }

  Object asJson() {
    return json.encode({
      "verify": verify,
      "username": username,
      "email": email,
      "password": password,
      "association": association,
      "role": role,
      "invitation": invitation,
    });
  }
}
