import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:http/http.dart';

import '../../auth/types/auth_session.dart';

class EventApi {
  Future<PaginatedList<MinimalEvent>> getEvents(
    AuthSession session,
    int page,
    int eventsPerPage,
  ) async {
    final AuthSession(:host, :token) = session;
    final uri =
        Uri.parse("$host/api/events?page=$page&per_page=$eventsPerPage");

    final response = await get(
      uri,
      headers: {'Authorization': "Bearer $token"},
    );

    return PaginatedList.fromResponseJson(response.bodyBytes, MinimalEvent.fromJson);
  }
}
