import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';

import '../../shared/types/paginated_list.dart';

class UserJourneyApi {
  final DioClient client;

  UserJourneyApi({required this.client});

  Future<PaginatedList<UserJourney>> getUserJourneys(
      int page,
      int userJourneysPerPage,
      int userId,
      ) async {
    final response = await client.dio.get(
      '/user-journeys/user/$userId',
      queryParameters: {
        'page': page,
        'per_page': userJourneysPerPage,
        'sort': 'created_at.desc'
      },
    );

    return PaginatedList.fromJson(response.data, UserJourney.fromJson);
  }

  Future<List<int>> getUserJourneyFile(int userJourneyId) async {
    final response = await client.dio.get(
      '/user-journeys/$userJourneyId/file',
    );

    return List<int>.from(response.data);
  }

  Future<void> deleteUserJourney(int userJourneyId) async {
    await client.dio.delete(
      '/user-journeys/$userJourneyId',
    );
  }
}