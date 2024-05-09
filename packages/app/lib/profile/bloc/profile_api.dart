import 'package:hollybike/auth/types/auth_session.dart';
import 'package:http/http.dart';

import '../types/profile.dart';

class ProfileApi {
  getSessionProfile(AuthSession session) async {
    final AuthSession(:host, :token) = session;
    final uri = Uri.parse("$host/api/users/me");

    final response = await get(
      uri,
      headers: {'Authorization': "Bearer $token"},
    );

    return Profile.fromResponseJson(response.body);
  }
}
