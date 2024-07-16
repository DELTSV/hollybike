import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/types/image_path_dto.dart';
import 'package:hollybike/profile/types/update_password.dart';
import 'package:hollybike/profile/types/update_profile.dart';
import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:hollybike/user/types/minimal_user.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

import '../types/profile.dart';

class ProfileApi {
  final DioClient client;
  final AuthPersistence authPersistence;

  ProfileApi({required this.client, required this.authPersistence});

  Future<Profile> getProfile(AuthSession profileSession) async {
    final AuthSession(:host, :token) = profileSession;
    final response = await client.dio.get("$host/api/users/me",
        options: Options(
          headers: {'Authorization': "Bearer $token"},
        ));
    return Profile.fromJson(response.data);
  }

  Future<MinimalUser> getUserById(int userId) async {
    final response = await client.dio.get("/profiles/$userId");
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

  Future<Profile> updateProfile(
    String username,
    String? description,
    File? image,
  ) async {
    final updateMe = UpdateProfile(username: username, role: description);

    final response = await client.dio.patch(
      "/users/me",
      data: updateMe.toJson(),
    );

    final updatedProfile = Profile.fromJson(response.data);

    if (image != null) {
      final response = await client.dio.post(
        "/users/me/profile-picture",
        data: FormData.fromMap({
          "file": await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
            contentType: MediaType.parse('image/png'),
          ),
        }),
      );

      final imagePath = ImagePathDto.fromJson(response.data);
      updatedProfile.withProfilePicture(imagePath.path);
    }

    return updatedProfile;
  }

  Future<void> updatePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final currentSession = await authPersistence.currentSession;

    if (currentSession == null) {
      throw Exception("No session found");
    }

    await Dio(
      BaseOptions(
        baseUrl: "${currentSession.host}/api",
        headers: {
          'Authorization': "Bearer ${currentSession.token}",
        },
      ),
    ).patch(
      "/users/me",
      data: UpdatePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordAgain: newPassword,
      ).toJson(),
    );
  }

  Future<void> resetPassword(String email, {String? host}) async {
    final currentSession = await authPersistence.currentSession;

    final apiHost = host ?? currentSession?.host;

    if (apiHost == null) {
      throw Exception("No session found");
    }

    await Dio(
      BaseOptions(
        baseUrl: "$apiHost/api",
      ),
    ).post(
      "/users/password/$email/send",
    );
  }
}
