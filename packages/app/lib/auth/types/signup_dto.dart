import 'dart:convert';

class SignupDto {
  final String username;
  final String email;
  final String password;
  final int association;

  const SignupDto({
    required this.username,
    required this.email,
    required this.password,
    required this.association,
  });

  static SignupDto fromMap(Map<String, dynamic> map) {
    const String usernameKey = "username";
    const String emailKey = "email";
    const String passwordKey = "password";
    const String associationKey = "association";

    final missingValues = [
      usernameKey,
      emailKey,
      passwordKey,
      associationKey,
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
      username: map[usernameKey] as String,
      email: map[emailKey] as String,
      password: map[passwordKey] as String,
      association: map[associationKey] as int,
    );
  }

  Object asJson() {
    return json.encode({
      "username": username,
      "email": email,
      "password": password,
      "association": association,
    });
  }
}
