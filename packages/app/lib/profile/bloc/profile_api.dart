import 'package:dio/dio.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../types/profile.dart';

class ProfileApi {
  final DioClient client;

  ProfileApi({required this.client});

  Future<Profile> getSessionProfile(AuthSession session) async {
    final AuthSession(:host, :token) = session;

    final response = await client.dio.get("$host/api/users/me", options: Options(
      headers: {'Authorization': "Bearer $token"},
    ));

    return Profile.fromJson(response.data);
  }

  Future<MinimalUser> getIdProfile(AuthSession session, int id) async {
    final response = await client.dio.get("/profiles/$id");

    return MinimalUser.fromJson(response.data);
  }

  Future<PaginatedList<MinimalUser>> searchUsers(
    int page,
    int eventsPerPage,
    String query,
  ) async {
    final response = await client.dio.get(
      "/profiles",
      queryParameters: {
        'page': page,
        'per_page': eventsPerPage,
        'sort': 'username.asc',
        "query": query,
      },
    );

    return PaginatedList.fromJson(response.data, MinimalUser.fromJson);
  }
}
