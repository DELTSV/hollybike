import 'package:hollybike/journey/type/journey.dart';

import '../../auth/types/auth_session.dart';
import '../../shared/http/dio_client.dart';
import '../../shared/types/paginated_list.dart';

class JourneyApi {
  Future<PaginatedList<Journey>> getJourneys(
    AuthSession session,
    int page,
    int journeysPerPage,
  ) async {
    final response = await DioClient(session).dio.get(
      '/journeys',
      queryParameters: {
        'page': page,
        'per_page': journeysPerPage,
        'sort': 'taken_date_time.desc'
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch journeys");
    }

    return PaginatedList.fromJson(response.data, Journey.fromJson);
  }
}
