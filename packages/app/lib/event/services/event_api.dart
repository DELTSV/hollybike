import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/shared/types/paginated_list.dart';

import '../../auth/types/auth_session.dart';
import '../types/create_event.dart';
import '../types/event.dart';

class EventApi {
  Future<PaginatedList<MinimalEvent>> getEvents(
    AuthSession session,
    int page,
    int eventsPerPage,
  ) async {
    final response = await DioClient(session).dio.get(
      '/events/future?sort=start_date_time.asc',
      queryParameters: {
        'page': page,
        'per_page': eventsPerPage,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch events");
    }

    return PaginatedList.fromJson(response.data, MinimalEvent.fromJson);
  }

  Future<Event> getEvent(AuthSession session, int eventId) async {
    final response = await DioClient(session).dio.get('/events/$eventId');

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch event");
    }

    return Event.fromJson(response.data);
  }

  Future<Event> createEvent(AuthSession session, CreateEventDTO event) async {
    final response = await DioClient(session).dio.post(
          '/events',
          data: event.toJson(),
        );

    if (response.statusCode != 201) {
      throw Exception("Failed to create event");
    }

    return Event.fromJson(response.data);
  }

  Future<void> publishEvent(AuthSession session, int eventId) async {
    final response = await DioClient(session).dio.patch(
          '/events/$eventId/schedule',
        );

    if (response.statusCode != 200) {
      throw Exception("Failed to publish event");
    }
  }
}
