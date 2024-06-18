import 'package:hollybike/shared/types/dto_compatible.dart';

import '../../auth/types/auth_session.dart';
import '../../shared/http/dio_client.dart';
import '../../shared/types/paginated_list.dart';

class SearchApi<D, F extends DtoCompatibleFactory<D>> {
  final F factory;

  SearchApi({required this.factory});

  Future<PaginatedList<D>> getEvents(
    AuthSession session,
    int page,
    int eventsPerPage,
  ) async {
    final response = await DioClient(session).dio.get(
      '/events',
      queryParameters: {
        'page': page,
        'per_page': eventsPerPage,
        'sort': 'start_date_time.asc',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch events");
    }

    return PaginatedList.fromJson(response.data, factory.fromJson);
  }
}
