import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/shared/utils/base64_to_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPersistence {
  Future<List<AuthSession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();

    final sessionsStringList = prefs.getStringList("sessions");
    if (sessionsStringList == null || sessionsStringList.isEmpty) {
      return <AuthSession>[];
    }

    final sessions = await Future.wait(
      sessionsStringList.map(AuthSession.fromJson).map(_isSessionValid),
    );
    return sessions.whereType<AuthSession>().toList();
  }

  Future<AuthSession?> _isSessionValid(AuthSession session) async {
    final AuthSession(:token) = session;
    final [_, data, _] = token.split(".");
    final object = base64ToObject(data);
    final expirationDate = DateTime.fromMillisecondsSinceEpoch(
      object["exp"] * 1000,
    );
    final currentDate = DateTime.now();

    return expirationDate.isAfter(currentDate) ? session : null;
  }
}
