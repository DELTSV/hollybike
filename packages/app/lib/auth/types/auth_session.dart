import 'dart:convert';

class AuthSession {
  String token;
  String host;

  AuthSession({required this.token, required this.host});

  String toJson() {
    return json.encode({
      "token": token,
      "host": host,
    });
  }

  static AuthSession fromJson(String json) {
    final object = jsonDecode(json);

    if (object["token"] == null) {
      throw const FormatException("Missing token inside json");
    }

    if (object["host"] == null) {
      throw const FormatException("Missing host inside json");
    }

    return AuthSession(
      token: object["token"] as String,
      host: object["host"] as String,
    );
  }

  static AuthSession fromResponseJson(String hostSource, String response) {
    final object = jsonDecode(response);

    if (object["token"] == null) {
      throw const FormatException("Missing token inside server response");
    }

    return AuthSession(token: object["token"] as String, host: hostSource);
  }
}
