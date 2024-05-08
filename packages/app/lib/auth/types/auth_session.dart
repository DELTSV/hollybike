import 'dart:convert';

class AuthSession {
  String token;
  String host;

  AuthSession({required this.token, required this.host});

  static AuthSession fromResponseJson(String hostSource, String response) {
    final object = jsonDecode(response);

    if (object["token"] == null) {
      throw const FormatException("Missing token inside server response");
    }

    return AuthSession(token: object["token"] as String, host: hostSource);
  }
}
