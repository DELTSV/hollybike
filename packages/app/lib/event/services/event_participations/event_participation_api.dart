import 'dart:developer';

import '../../../auth/types/auth_session.dart';
import '../../../shared/http/dio_client.dart';
import '../../../shared/types/paginated_list.dart';
import '../../types/event_participation.dart';

class EventParticipationsApi {
  Future<PaginatedList<EventParticipation>> getParticipations(
    int eventId,
    AuthSession session,
    int page,
    int eventsPerPage,
  ) async {
    final response = await DioClient(session).dio.get(
      '/events/$eventId/participations',
      queryParameters: {
        'page': page,
        'per_page': eventsPerPage,
        'sort': 'joined_date_time.asc',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch participations");
    }

    return PaginatedList.fromJson(response.data, EventParticipation.fromJson);
  }

  Future<void> promoteParticipant(
    int eventId,
    int userId,
    AuthSession session,
  ) async {
    final response = await DioClient(session).dio.patch(
      '/events/$eventId/participations/$userId/promote',
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to promote participation");
    }
  }

  Future<void> demoteParticipant(
    int eventId,
    int userId,
    AuthSession session,
  ) async {
    final response = await DioClient(session).dio.patch(
      '/events/$eventId/participations/$userId/demote',
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to demote participation");
    }
  }

  Future<void> removeParticipant(
    int eventId,
    int userId,
    AuthSession session,
  ) async {
    final response = await DioClient(session).dio.delete(
      '/events/$eventId/participations/$userId',
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to remove participation");
    }
  }
}
