import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/types/image_path_dto.dart';
import 'package:hollybike/profile/types/update_profile.dart';
import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:hollybike/user/types/minimal_user.dart';
import 'package:image/image.dart' as img;

// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

import '../types/profile.dart';

class ProfileApi {
  final DioClient client;

  ProfileApi({required this.client});

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

  Future<Uint8List> applyRoundedCorners(String imagePath) async {
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image == null) {
      throw Exception("Failed to decode image");
    }

    final alphaImage = img.copyCropCircle(
      image.convert(numChannels: 4),
    );

    final resizedImage = img.copyResize(
      alphaImage,
      width: 256,
      height: 256,
    );

    return img.encodePng(resizedImage);
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
      final roundedImage = await applyRoundedCorners(image.path);

      final response = await client.dio.post(
        "/users/me/profile-picture",
        data: FormData.fromMap({
          "file": MultipartFile.fromBytes(
            roundedImage,
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
}
