import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/shared/types/paginated_list.dart';

import '../../../auth/types/auth_session.dart';
import '../../types/event.dart';
import '../../types/event_details.dart';
import '../../types/participation/event_participation.dart';

class EventApi {
  Future<PaginatedList<MinimalEvent>> getEvents(
    AuthSession session,
    String requestType,
    int page,
    int eventsPerPage, {
    int? userId,
  }) async {
    final response = await DioClient(session).dio.get(
          '/events/$requestType',
          queryParameters: {
            'page': page,
            'per_page': eventsPerPage,
            'sort': 'start_date_time.asc',
          }..addAll(userId == null ? {} : {"participant_id": "eq:$userId"}),
        );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch events");
    }

    return PaginatedList.fromJson(response.data, MinimalEvent.fromJson);
  }

  Future<EventDetails> getEventDetails(AuthSession session, int eventId) async {
    final response =
        await DioClient(session).dio.get('/events/$eventId/details');

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch event details");
    }

    return EventDetails.fromJson(response.data);
  }

  Future<Event> createEvent(AuthSession session, EventFormData event) async {
    final response = await DioClient(session).dio.post(
          '/events',
          data: event.toJson(),
        );

    if (response.statusCode != 201) {
      throw Exception("Failed to create event");
    }

    return Event.fromJson(response.data);
  }

  Future<Event> editEvent(
      AuthSession session, int eventId, EventFormData event) async {
    final response = await DioClient(session).dio.put(
          '/events/$eventId',
          data: event.toJson(),
        );

    if (response.statusCode != 200) {
      throw Exception("Failed to edit event");
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

  Future<EventParticipation> joinEvent(AuthSession session, int eventId) async {
    final response = await DioClient(session).dio.post(
          '/events/$eventId/participations',
        );

    if (response.statusCode != 201) {
      throw Exception("Failed to join event");
    }

    return EventParticipation.fromJson(response.data);
  }

  Future<void> deleteEvent(AuthSession session, int eventId) async {
    final response = await DioClient(session).dio.delete(
          '/events/$eventId',
        );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete event");
    }
  }

  Future<void> leaveEvent(AuthSession session, int eventId) async {
    final response = await DioClient(session).dio.delete(
          '/events/$eventId/participations',
        );

    if (response.statusCode != 200) {
      throw Exception("Failed to leave event");
    }
  }

  Future<void> cancelEvent(AuthSession session, int eventId) async {
    final response = await DioClient(session).dio.patch(
          '/events/$eventId/cancel',
        );

    if (response.statusCode != 200) {
      throw Exception("Failed to cancel event");
    }
  }

  Future<void> addJourneyToEvent(
    AuthSession session,
    int eventId,
    int journeyId,
  ) async {
    final response = await DioClient(session).dio.post(
      '/events/$eventId/journey',
      data: {
        'journey_id': journeyId,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add journey to event");
    }
  }
}
