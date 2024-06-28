import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:http/http.dart';

import '../types/profile.dart';

class ProfileApi {
  final DioClient _dioClient;

  ProfileApi({required authPersistence}) : _dioClient = DioClient(authPersistence: authPersistence);

  Future<Profile> getSessionProfile(AuthSession session) async {
    final AuthSession(:host, :token) = session;
    final uri = Uri.parse("$host/api/users/me");

    final response = await get(
      uri,
      headers: {'Authorization': "Bearer $token"},
    );

    if (response.statusCode != 200) throw Exception("Failed to fetch user");

    return Profile.fromResponseJson(response.bodyBytes);
  }

  Future<MinimalUser> getIdProfile(AuthSession session, int id) async {
    final response = await _dioClient.dio.get("/profiles/$id");

    if (response.statusCode != 200) throw Exception("Failed to fetch user");

    return MinimalUser.fromJson(response.data);
  }

  Future<PaginatedList<MinimalUser>> searchUsers(
    AuthSession session,
    int page,
    int eventsPerPage,
    String query,
  ) async {
    final response = await _dioClient.dio.get(
      "/profiles",
      queryParameters: {
        'page': page,
        'per_page': eventsPerPage,
        'sort': 'username.asc',
        "query": query,
      },
    );

    if (response.statusCode != 200) throw Exception("Failed to fetch users");

    return PaginatedList.fromJson(response.data, MinimalUser.fromJson);
  }
}
