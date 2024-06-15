import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/auth/types/expired_token_exception.dart';
import 'package:http/http.dart';

import '../types/profile.dart';

class ProfileApi {
  Future<Profile> getSessionProfile(AuthSession session) async {
    final AuthSession(:host, :token) = session;
    final uri = Uri.parse("$host/api/users/me");

    final response = await get(
      uri,
      headers: {'Authorization': "Bearer $token"},
    );

    if (response.statusCode == 401) throw ExpiredTokenException();

    return Profile.fromResponseJson(response.bodyBytes);
  }

  Future<Profile> getIdProfile(AuthSession currentSession, int id) async {
    final uri = Uri.parse("${currentSession.host}/api/users/$id");

    final response = await get(
      uri,
      headers: {'Authorization': "Bearer ${currentSession.token}"},
    );

    if (response.statusCode == 401) throw ExpiredTokenException();

    return Profile.fromResponseJson(response.bodyBytes);
  }
}
