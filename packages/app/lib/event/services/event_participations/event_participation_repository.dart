import 'package:hollybike/event/types/event_candidate.dart';
import 'package:hollybike/event/types/event_participation.dart';
import 'package:hollybike/event/types/event_role.dart';
import 'package:rxdart/rxdart.dart';

import '../../../auth/types/auth_session.dart';
import '../../../shared/types/paginated_list.dart';
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
    AuthSession session,
    int page,
    int eventsPerPage,
    String? search,
  ) async {
    final pageResult = await eventParticipationsApi.getCandidates(
      eventId,
      session,
      page,
      eventsPerPage,
      search,
    );

    _eventCandidatesStreamController.add(
      _eventCandidatesStreamController.value + pageResult.items,
    );

    return pageResult;
  }

  Future<PaginatedList<EventCandidate>> refreshCandidates(
    int eventId,
    AuthSession session,
    int eventsPerPage,
    String? search,
  ) async {
    final pageResult = await eventParticipationsApi.getCandidates(
      eventId,
      session,
      0,
      eventsPerPage,
      search,
    );

    _eventCandidatesStreamController.add(
      pageResult.items,
    );

    return pageResult;
  }

  Future<PaginatedList<EventParticipation>> fetchParticipations(
    int eventId,
    AuthSession session,
    int page,
    int eventsPerPage,
  ) async {
    final pageResult = await eventParticipationsApi.getParticipations(
      eventId,
      session,
      page,
      eventsPerPage,
    );

    _eventParticipationsStreamController.add(
      _eventParticipationsStreamController.value + pageResult.items,
    );

    return pageResult;
  }

  Future<PaginatedList<EventParticipation>> refreshParticipations(
    int eventId,
    AuthSession session,
    int eventsPerPage,
  ) async {
    final pageResult = await eventParticipationsApi.getParticipations(
      eventId,
      session,
      0,
      eventsPerPage,
    );

    _eventParticipationsStreamController.add(
      pageResult.items,
    );

    return pageResult;
  }

  Future<void> promoteParticipant(
    int eventId,
    int userId,
    AuthSession session,
  ) async {
    await eventParticipationsApi.promoteParticipant(
      eventId,
      userId,
      session,
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
    AuthSession session,
  ) async {
    await eventParticipationsApi.demoteParticipant(
      eventId,
      userId,
      session,
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
    AuthSession session,
  ) async {
    await eventParticipationsApi.removeParticipant(
      eventId,
      userId,
      session,
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
}
