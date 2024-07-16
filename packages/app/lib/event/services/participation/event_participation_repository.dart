/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import '../../../shared/types/paginated_list.dart';
import '../../../shared/utils/streams/stream_mapper.dart';
import '../../../shared/utils/streams/stream_value.dart';
import '../../types/participation/event_candidate.dart';
import '../../types/participation/event_participation.dart';
import '../../types/participation/event_role.dart';
import 'event_participation_api.dart';

class EventParticipationRepository {
  final EventParticipationsApi eventParticipationsApi;

  final _eventParticipationsStreamMapper =
      StreamMapper<List<EventParticipation>, void>(seedValue: []);
  final _eventCandidatesStreamMapper =
      StreamMapper<List<EventCandidate>, void>(seedValue: []);

  EventParticipationRepository({required this.eventParticipationsApi});

  Stream<StreamValue<List<EventCandidate>, void>> candidatesStream(
          int eventId) =>
      _eventCandidatesStreamMapper.stream(eventId);

  Stream<StreamValue<List<EventParticipation>, void>> participationsStream(
          int eventId) =>
      _eventParticipationsStreamMapper.stream(eventId);

  Future<PaginatedList<EventCandidate>> fetchCandidates(
    int eventId,
    int page,
    int candidatesPerPage,
    String? search,
  ) async {
    final pageResult = await eventParticipationsApi.getCandidates(
      eventId,
      page,
      candidatesPerPage,
      search,
    );

    final candidates = _eventCandidatesStreamMapper.get(eventId);

    if (candidates != null) {
      _eventCandidatesStreamMapper.add(
        eventId,
        candidates + pageResult.items,
      );
    }

    return pageResult;
  }

  Future<PaginatedList<EventCandidate>> refreshCandidates(
    int eventId,
    int candidatesPerPage,
    String? search,
  ) async {
    final pageResult = await eventParticipationsApi.getCandidates(
      eventId,
      0,
      candidatesPerPage,
      search,
    );

    _eventCandidatesStreamMapper.add(
      eventId,
      pageResult.items,
    );

    return pageResult;
  }

  Future<PaginatedList<EventParticipation>> fetchParticipations(
    int eventId,
    int page,
    int participationsPerPage,
  ) async {
    final pageResult = await eventParticipationsApi.getParticipations(
      eventId,
      page,
      participationsPerPage,
    );

    final participations = _eventParticipationsStreamMapper.get(eventId);

    if (participations != null) {
      _eventParticipationsStreamMapper.add(
        eventId,
        participations + pageResult.items,
      );
    }

    return pageResult;
  }

  Future<PaginatedList<EventParticipation>> refreshParticipations(
    int eventId,
    int participationsPerPage,
  ) async {
    final pageResult = await eventParticipationsApi.getParticipations(
      eventId,
      0,
      participationsPerPage,
    );

    _eventParticipationsStreamMapper.add(
      eventId,
      pageResult.items,
    );

    return pageResult;
  }

  Future<void> promoteParticipant(
    int eventId,
    int userId,
  ) async {
    await eventParticipationsApi.promoteParticipant(
      eventId,
      userId,
    );

    final participations = _eventParticipationsStreamMapper.get(eventId);

    if (participations != null) {
      _eventParticipationsStreamMapper.add(
        eventId,
        participations
            .map((participation) => participation.user.id == userId
                ? participation.copyWith(role: EventRole.organizer)
                : participation)
            .toList(),
      );
    }
  }

  Future<void> demoteParticipant(
    int eventId,
    int userId,
  ) async {
    await eventParticipationsApi.demoteParticipant(
      eventId,
      userId,
    );
    final participations = _eventParticipationsStreamMapper.get(eventId);

    if (participations != null) {
      _eventParticipationsStreamMapper.add(
        eventId,
        participations
            .map((participation) => participation.user.id == userId
                ? participation.copyWith(role: EventRole.member)
                : participation)
            .toList(),
      );
    }
  }

  Future<void> removeParticipant(
    int eventId,
    int userId,
  ) async {
    await eventParticipationsApi.removeParticipant(
      eventId,
      userId,
    );

    final participations = _eventParticipationsStreamMapper.get(eventId);

    if (participations != null) {
      _eventParticipationsStreamMapper.add(
        eventId,
        participations
            .where((participation) => participation.user.id != userId)
            .toList(),
      );
    }
  }

  Future<List<EventParticipation>> addParticipants(
    int eventId,
    List<int> userIds,
    int participationsPerPage,
  ) async {
    final participations = await eventParticipationsApi.addParticipants(
      eventId,
      userIds,
    );

    await refreshParticipations(
      eventId,
      participationsPerPage,
    );

    return participations;
  }

  void onUserJourneyRemoved(int userJourneyId) {
    for (final counter in _eventParticipationsStreamMapper.counters) {
      counter.add(
          counter.value.map((participation) {
            if (participation.journey?.id == userJourneyId) {
              return EventParticipation(
                isImagesPublic: participation.isImagesPublic,
                user: participation.user,
                role: participation.role,
                joinedDateTime: participation.joinedDateTime,
                journey: null,
              );
            }

            return participation;
          }).toList()
      );
    }
  }
}
