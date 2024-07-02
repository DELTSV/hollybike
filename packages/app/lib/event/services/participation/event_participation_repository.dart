import 'package:rxdart/rxdart.dart';

import '../../../shared/types/paginated_list.dart';
import '../../types/participation/event_candidate.dart';
import '../../types/participation/event_participation.dart';
import '../../types/participation/event_role.dart';
import 'event_participation_api.dart';

class EventParticipationRepository {
  final EventParticipationsApi eventParticipationsApi;

  final _eventParticipationsStreamControllerMap = <int, BehaviorSubject<List<EventParticipation>>>{};
  final _eventCandidatesStreamControllerMap = <int, BehaviorSubject<List<EventCandidate>>>{};

  EventParticipationRepository({required this.eventParticipationsApi});

  Stream<List<EventCandidate>> candidatesStream(int eventId) {
    return _eventCandidatesStreamControllerMap.putIfAbsent(
      eventId,
      () => BehaviorSubject<List<EventCandidate>>(),
    ).stream;
  }

  Stream<List<EventParticipation>> participationsStream(int eventId) {
    return _eventParticipationsStreamControllerMap.putIfAbsent(
      eventId,
      () => BehaviorSubject<List<EventParticipation>>(),
    ).stream;
  }

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

    if (_eventCandidatesStreamControllerMap[eventId] != null) {
      _eventCandidatesStreamControllerMap[eventId]!.add(
        _eventCandidatesStreamControllerMap[eventId]!.value + pageResult.items,
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

    _eventCandidatesStreamControllerMap[eventId]?.add(
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

    if (_eventParticipationsStreamControllerMap[eventId] != null) {
      _eventParticipationsStreamControllerMap[eventId]!.add(
        _eventParticipationsStreamControllerMap[eventId]!.value + pageResult.items,
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

    _eventParticipationsStreamControllerMap[eventId]?.add(
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

    if (_eventParticipationsStreamControllerMap[eventId] == null) {
      return;
    }

    _eventParticipationsStreamControllerMap[eventId]?.add(
      _eventParticipationsStreamControllerMap[eventId]!.value
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

    if (_eventParticipationsStreamControllerMap[eventId] == null) {
      return;
    }

    _eventParticipationsStreamControllerMap[eventId]?.add(
      _eventParticipationsStreamControllerMap[eventId]!.value
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

    if (_eventParticipationsStreamControllerMap[eventId] == null) {
      return;
    }

    _eventParticipationsStreamControllerMap[eventId]?.add(
      _eventParticipationsStreamControllerMap[eventId]!.value
          .where((participation) => participation.user.id != userId)
          .toList(),
    );
  }

  Future<void> closeParticipations(int eventId) async {
    await _eventParticipationsStreamControllerMap[eventId]?.close();
    _eventParticipationsStreamControllerMap.remove(eventId);
  }

  Future<void> closeCandidates(int eventId) async {
    await _eventCandidatesStreamControllerMap[eventId]?.close();
    _eventCandidatesStreamControllerMap.remove(eventId);
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
