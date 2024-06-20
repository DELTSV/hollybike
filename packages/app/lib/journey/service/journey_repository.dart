import 'dart:io';

import 'package:hollybike/journey/service/journey_api.dart';

import '../../auth/types/auth_session.dart';
import '../../shared/types/paginated_list.dart';
import '../type/journey.dart';

class JourneyRepository {
  final JourneyApi journeyApi;

  JourneyRepository({required this.journeyApi});

  Future<PaginatedList<Journey>> fetchJourneys(
    AuthSession session,
    int page,
    int eventsPerPage,
  ) async {
    final pageResult = await journeyApi.getJourneys(
      session,
      page,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<PaginatedList<Journey>> refreshJourneys(
    AuthSession session,
    int eventsPerPage,
  ) async {
    final pageResult = await journeyApi.getJourneys(
      session,
      0,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<Journey> createJourney(AuthSession session, String name) async {
    final journey = await journeyApi.createJourney(session, name);

    return journey;
  }

  Future<Journey> uploadJourneyFile(
    AuthSession session,
    int journeyId,
    File file,
  ) async {
    final journey = await journeyApi.uploadJourneyFile(
      session,
      journeyId,
      file,
    );

    return journey;
  }

  Future<Journey> getPositions(AuthSession session, int journeyId) async {
    final journey = await journeyApi.getPositions(session, journeyId);

    return journey;
  }
}
