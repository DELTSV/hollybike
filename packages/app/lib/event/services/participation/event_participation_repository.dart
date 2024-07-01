import 'package:rxdart/rxdart.dart';

import '../../../shared/types/paginated_list.dart';
import '../../types/participation/event_candidate.dart';
import '../../types/participation/event_participation.dart';
import '../../types/participation/event_role.dart';
import 'event_participation_api.dart';

class EventParticipationRepository {
  final EventParticipationsApi eventParticipationsApi;

  late final _eventParticipationsStreamController =
      BehaviorSubject<List<EventParticipation>>.seeded([]);

  late final _eventCandidatesStreamController =
      BehaviorSubject<List<EventCandidate>>.seeded([]);

  Stream<List<EventCandidate>> get candidatesStream =>
      _eventCandidatesStreamController.stream;

  Stream<List<EventParticipation>> get participationsStream =>
      _eventParticipationsStreamController.stream;

  EventParticipationRepository({required this.eventParticipationsApi});

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

    _eventCandidatesStreamController.add(
      _eventCandidatesStreamController.value + pageResult.items,
    );

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

    _eventCandidatesStreamController.add(
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

    _eventParticipationsStreamController.add(
      _eventParticipationsStreamController.value + pageResult.items,
    );

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

    _eventParticipationsStreamController.add(
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

    _eventParticipationsStreamController.add(
      _eventParticipationsStreamController.value
          .map((participation) => participation.user.id == userId
              ? participation.copyWith(role: EventRole.organizer)
              : participation)
          .toList(),
    );
  }

  Future<void> demoteParticipant(
    int eventId,
    int userId,
  ) async {
    await eventParticipationsApi.demoteParticipant(
      eventId,
      userId,
    );

    _eventParticipationsStreamController.add(
      _eventParticipationsStreamController.value
          .map((participation) => participation.user.id == userId
              ? participation.copyWith(role: EventRole.member)
              : participation)
          .toList(),
    );
  }

  Future<void> removeParticipant(
    int eventId,
    int userId,
  ) async {
    await eventParticipationsApi.removeParticipant(
      eventId,
      userId,
    );

    _eventParticipationsStreamController.add(
      _eventParticipationsStreamController.value
          .where((participation) => participation.user.id != userId)
          .toList(),
    );
  }

  Future<void> close() async {
    _eventParticipationsStreamController.close();
    _eventCandidatesStreamController.close();
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
}
