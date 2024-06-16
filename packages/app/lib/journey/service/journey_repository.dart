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
}
