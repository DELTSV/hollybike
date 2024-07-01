import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hollybike/journey/type/journey.dart';

import '../../auth/types/auth_session.dart';
import '../../shared/http/dio_client.dart';
import '../../shared/types/paginated_list.dart';

class JourneyApi {
  final DioClient client;

  JourneyApi({required this.client});

  Future<PaginatedList<Journey>> getJourneys(
    AuthSession session,
    int page,
    int journeysPerPage,
  ) async {
    final response = await client.dio.get(
      '/journeys',
      queryParameters: {
        'page': page,
        'per_page': journeysPerPage,
        'sort': 'created_at.desc'
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch journeys");
    }

    return PaginatedList.fromJson(response.data, Journey.fromJson);
  }

  Future<Journey> createJourney(AuthSession session, String name) async {
    final response = await client.dio.post('/journeys', data: {
      'name': name,
    });

    if (response.statusCode != 201) {
      throw Exception("Failed to create journey");
    }

    return Journey.fromJson(response.data);
  }

  Future<Journey> uploadJourneyFile(
    AuthSession session,
    int journeyId,
    File file,
  ) async {
    final response = await client.dio.post(
          '/journeys/$journeyId/file',
          data: FormData.fromMap({
            'file': await MultipartFile.fromFile(file.path),
          }),
        );

    if (response.statusCode != 200) {
      throw Exception("Failed to upload journey file");
    }

    return Journey.fromJson(response.data);
  }

  Future<Journey> getPositions(AuthSession session, int journeyId) async {
    final response = await client.dio.get('/journeys/$journeyId/positions');

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch journey positions");
    }

    return Journey.fromJson(response.data);
  }
}
