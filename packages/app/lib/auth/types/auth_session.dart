import 'dart:convert';

import 'package:hollybike/shared/utils/verify_object_attributes_not_null.dart';

class AuthSession {
  String token;
  String refreshToken;
  String deviceId;
  String host;

  AuthSession({
    required this.token,
    required this.host,
    required this.refreshToken,
    required this.deviceId,
  });

  String toJson() {
    return json.encode({
      "token": token,
      "refresh_token": refreshToken,
      "device_id": deviceId,
      "host": host,
    });
  }

  @override
  bool operator ==(covariant AuthSession other) {
    return host == other.host &&
        token == other.token &&
        refreshToken == other.refreshToken &&
        deviceId == other.deviceId;
  }

  int? getIndexInList(List<AuthSession> list) {
    if (list.isNotEmpty) {
      int index;
      for (index = 0; index < list.length; index++) {
        final sessionFromIndex = list[index];
        if (this == sessionFromIndex) {
          return index;
        }
      }
    }
    return null;
  }

  factory AuthSession.fromJson(String json) {
    final object = jsonDecode(json);

    verifyObjectAttributesNotNull(
      object,
      [
        "token",
        "refresh_token",
        "device_id",
        "host",
      ],
    );

    return AuthSession(
      token: object["token"] as String,
      refreshToken: object["refresh_token"] as String,
      deviceId: object["device_id"] as String,
      host: object["host"] as String,
    );
  }

  factory AuthSession.fromResponseJson(String hostSource, Map<String, dynamic> json) {
    verifyObjectAttributesNotNull(
      json,
      [
        "token",
        "refresh_token",
        "deviceId",
      ],
    );

    return AuthSession(
      token: json["token"] as String,
      refreshToken: json["refresh_token"] as String,
      deviceId: json["deviceId"] as String,
      host: hostSource,
    );
  }
}
