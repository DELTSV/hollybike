import 'dart:io';

import 'package:hollybike/journey/service/journey_api.dart';

import '../../shared/types/paginated_list.dart';
import '../type/journey.dart';

class JourneyRepository {
  final JourneyApi journeyApi;

  JourneyRepository({required this.journeyApi});

  Future<PaginatedList<Journey>> fetchJourneys(
    int page,
    int eventsPerPage,
  ) async {
    final pageResult = await journeyApi.getJourneys(
      page,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<PaginatedList<Journey>> refreshJourneys(
    int eventsPerPage,
  ) async {
    final pageResult = await journeyApi.getJourneys(
      0,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<Journey> createJourney(String name) async {
    final journey = await journeyApi.createJourney(name);

    return journey;
  }

  Future<Journey> uploadJourneyFile(
    int journeyId,
    File file,
  ) async {
    final journey = await journeyApi.uploadJourneyFile(
      journeyId,
      file,
    );

    return journey;
  }

  Future<Journey> getPositions(int journeyId) async {
    final journey = await journeyApi.getPositions(journeyId);

    return journey;
  }
}
