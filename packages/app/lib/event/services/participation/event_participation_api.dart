/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import '../../../shared/http/dio_client.dart';
import '../../../shared/types/paginated_list.dart';
import '../../types/participation/event_candidate.dart';
import '../../types/participation/event_participation.dart';

class EventParticipationsApi {
  final DioClient client;

  EventParticipationsApi({required this.client});

  Future<PaginatedList<EventParticipation>> getParticipations(
    int eventId,
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

    return PaginatedList.fromJson(response.data, EventParticipation.fromJson);
  }

  Future<PaginatedList<EventCandidate>> getCandidates(
    int eventId,
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

    return PaginatedList.fromJson(response.data, EventCandidate.fromJson);
  }

  Future<void> promoteParticipant(
    int eventId,
    int userId,
  ) async {
    await client.dio.patch(
      '/events/$eventId/participations/$userId/promote',
    );
  }

  Future<void> demoteParticipant(
    int eventId,
    int userId,
  ) async {
    await client.dio.patch(
      '/events/$eventId/participations/$userId/demote',
    );
  }

  Future<void> removeParticipant(
    int eventId,
    int userId,
  ) async {
    await client.dio.delete(
      '/events/$eventId/participations/$userId',
    );
  }

  Future<List<EventParticipation>> addParticipants(
    int eventId,
    List<int> userIds,
  ) async {
    final response = await client.dio.post(
      '/events/$eventId/participations/add-users',
      data: {
        'userIds': userIds,
      },
    );

    return List<EventParticipation>.from(
      response.data
          .map((participation) => EventParticipation.fromJson(participation)),
    );
  }
}
