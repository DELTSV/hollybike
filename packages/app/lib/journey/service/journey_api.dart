import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hollybike/journey/type/journey.dart';

import '../../shared/http/dio_client.dart';
import '../../shared/types/paginated_list.dart';

class JourneyApi {
  final DioClient client;

  JourneyApi({required this.client});

  Future<PaginatedList<Journey>> getJourneys(
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

    return PaginatedList.fromJson(response.data, Journey.fromJson);
  }

  Future<Journey> createJourney(String name) async {
    final response = await client.dio.post('/journeys', data: {
      'name': name,
    });

    return Journey.fromJson(response.data);
  }

  Future<Journey> uploadJourneyFile(
    int journeyId,
    File file,
  ) async {
    final response = await client.dio.post(
      '/journeys/$journeyId/file',
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      }),
    );

    return Journey.fromJson(response.data);
  }

  Future<Journey> getPositions(int journeyId) async {
    final response = await client.dio.get('/journeys/$journeyId/positions');

    return Journey.fromJson(response.data);
  }

  Future<void> deleteJourney(int journeyId) async {
    await client.dio.delete('/journeys/$journeyId');
  }
}
