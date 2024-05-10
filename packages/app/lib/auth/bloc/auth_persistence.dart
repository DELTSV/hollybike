import 'package:hollybike/auth/types/auth_session.dart';
import 'package:http/http.dart';
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
    return sessions
        .whereType<AuthSession>()
        .toList();
  }

  Future<AuthSession?> _isSessionValid(AuthSession session) async {
    final AuthSession(:host, :token) = session;
    final uri = Uri.parse("$host/api/users/me");

    final response = await get(
      uri,
      headers: {'Authorization': "Bearer $token"},
    );

    return response.statusCode == 200 ? session : null;
  }
}
