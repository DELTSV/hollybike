import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:http/http.dart';

import '../../auth/types/auth_session.dart';

class EventApi {
  Future<PaginatedList<Event>> getEvents(AuthSession session) async {
    final AuthSession(:host, :token) = session;
    final uri = Uri.parse("$host/api/events");

    final response = await get(
      uri,
      headers: {'Authorization': "Bearer $token"},
    );

    return PaginatedList.fromResponseJson(response.body, Event.fromJson);
  }
}
