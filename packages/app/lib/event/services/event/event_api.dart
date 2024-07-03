import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/shared/types/paginated_list.dart';

import '../../../journey/type/user_journey.dart';
import '../../types/event.dart';
import '../../types/event_details.dart';
import '../../types/participation/event_participation.dart';

class EventApi {
  final DioClient client;

  EventApi({required this.client});

  Future<PaginatedList<MinimalEvent>> getEvents(
    String? requestType,
    int page,
    int eventsPerPage, {
    int? userId,
    String? query,
  }) async {
    var sortDirection = 'asc';

    if (requestType == "archived") {
      sortDirection = 'desc';
    }

    final response = await client.dio.get(
      '/events${requestType == null ? "" : "/$requestType"}',
      queryParameters: {
        'page': page,
        'per_page': eventsPerPage,
        'sort': 'start_date_time.$sortDirection',
      }
        ..addAll(userId == null ? {} : {"participant_id": "eq:$userId"})
        ..addAll(query == null ? {} : {"query": query}),
    );

    return PaginatedList.fromJson(response.data, MinimalEvent.fromJson);
  }

  Future<EventDetails> getEventDetails(int eventId) async {
    final response = await client.dio.get('/events/$eventId/details');

    return EventDetails.fromJson(response.data);
  }

  Future<Event> createEvent(EventFormData event) async {
    final response = await client.dio.post(
      '/events',
      data: event.toJson(),
    );

    return Event.fromJson(response.data);
  }

  Future<Event> editEvent(int eventId, EventFormData event) async {
    final response = await client.dio.put(
      '/events/$eventId',
      data: event.toJson(),
    );

    return Event.fromJson(response.data);
  }

  Future<void> publishEvent(int eventId) async {
    await client.dio.patch(
      '/events/$eventId/schedule',
    );
  }

  Future<EventParticipation> joinEvent(int eventId) async {
    final response = await client.dio.post(
      '/events/$eventId/participations',
    );

    return EventParticipation.fromJson(response.data);
  }

  Future<void> deleteEvent(int eventId) async {
    await client.dio.delete(
      '/events/$eventId',
    );
  }

  Future<void> leaveEvent(int eventId) async {
    await client.dio.delete(
      '/events/$eventId/participations',
    );
  }

  Future<void> cancelEvent(int eventId) async {
    await client.dio.patch(
      '/events/$eventId/cancel',
    );
  }

  Future<void> addJourneyToEvent(
    int eventId,
    int journeyId,
  ) async {
    await client.dio.post(
      '/events/$eventId/journey',
      data: {
        'journey_id': journeyId,
      },
    );
  }

  Future<void> removeJourneyFromEvent(
    int eventId,
  ) async {
    await client.dio.delete(
      '/events/$eventId/journey',
    );
  }

  Future<UserJourney> terminateUserJourney(
    int eventId,
  ) async {
    final response = await client.dio.post(
      '/events/$eventId/participations/me/journey/terminate',
    );

    return UserJourney.fromJson(response.data);
  }
}
