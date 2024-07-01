import '../../../auth/types/auth_session.dart';
import '../../../shared/http/dio_client.dart';
import '../../../shared/types/paginated_list.dart';
import '../../types/participation/event_candidate.dart';
import '../../types/participation/event_participation.dart';

class EventParticipationsApi {
  final DioClient client;

  EventParticipationsApi({required this.client});

  Future<PaginatedList<EventParticipation>> getParticipations(
    int eventId,
    AuthSession session,
    int page,
    int eventsPerPage,
  ) async {
    final response = await client.dio.get(
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

  Future<PaginatedList<EventCandidate>> getCandidates(
    int eventId,
    AuthSession session,
    int page,
    int eventsPerPage,
    String? search,
  ) async {
    final queryParams = Map<String, dynamic>.from({
      'page': page,
      'per_page': eventsPerPage,
      'sort': 'username.asc',
    });

    if (search != null && search.isNotEmpty) {
      queryParams['query'] = search;
    } else {
      queryParams['joined_date_time'] = 'isnull';
    }

    final response = await client.dio.get(
      '/events/$eventId/participations/candidates',
      queryParameters: queryParams,
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch candidates");
    }

    return PaginatedList.fromJson(response.data, EventCandidate.fromJson);
  }

  Future<void> promoteParticipant(
    int eventId,
    int userId,
    AuthSession session,
  ) async {
    final response = await client.dio.patch(
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
    final response = await client.dio.patch(
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
    final response = await client.dio.delete(
      '/events/$eventId/participations/$userId',
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to remove participation");
    }
  }

  Future<List<EventParticipation>> addParticipants(
    int eventId,
    AuthSession session,
    List<int> userIds,
  ) async {
    final response = await client.dio.post(
      '/events/$eventId/participations/add-users',
      data: {
        'userIds': userIds,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add participants");
    }

    return List<EventParticipation>.from(
      response.data
          .map((participation) => EventParticipation.fromJson(participation)),
    );
  }
}
