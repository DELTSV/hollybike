/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:convert';

class LoginDto {
  final String email;
  final String password;

  const LoginDto({required this.email, required this.password});

  static LoginDto fromMap(Map<String, String> map) {
    const String emailKey = "email";
    const String passwordKey = "password";

    final missingValues = [emailKey, passwordKey].where(
      (keyName) => map[keyName] == null,
    );
    if (missingValues.isNotEmpty) {
      const String separator = "\n- ";
      final List<String> prefix = [
        '$map cannot be converted to LoginDto missing values for :',
      ];
      throw FormatException((prefix + missingValues.toList()).join(separator));
    }

    return LoginDto(
      email: map[emailKey] as String,
      password: map[passwordKey] as String,
    );
  }

  Object asJson() {
    return json.encode({
      "email": email,
      "password": password,
    });
  }
}
