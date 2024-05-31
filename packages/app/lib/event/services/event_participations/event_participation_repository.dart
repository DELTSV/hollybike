import 'package:hollybike/event/types/event_participation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../auth/types/auth_session.dart';
import '../../../shared/types/paginated_list.dart';
import 'event_participation_api.dart';

class EventParticipationRepository {
  final EventParticipationsApi eventParticipationsApi;

  late final _eventParticipationsStreamController =
      BehaviorSubject<List<EventParticipation>>.seeded([]);

  Stream<List<EventParticipation>> get participationsStream =>
      _eventParticipationsStreamController.stream;

  EventParticipationRepository({required this.eventParticipationsApi});

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

  Future<PaginatedList<EventParticipation>> getParticipationsPreviewData(
    int eventId,
    AuthSession session,
  ) async {
    final pageResult = await eventParticipationsApi.getParticipations(
      eventId,
      session,
      0,
      5,
    );

    return pageResult;
  }

  Future<void> close() async {
    _eventParticipationsStreamController.close();
  }
}
