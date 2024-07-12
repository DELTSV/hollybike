import 'package:hollybike/user_journey/services/user_journey_api.dart';

import '../../shared/types/paginated_list.dart';
import '../type/user_journey.dart';

class UserJourneyRepository {
  final UserJourneyApi userJourneyApi;

  UserJourneyRepository({required this.userJourneyApi});

  Future<PaginatedList<UserJourney>> fetchUserJourneys(
    int page,
    int userJourneysPerPage,
    int userId,
  ) async {
    final pageResult = await userJourneyApi.getUserJourneys(
      page,
      userJourneysPerPage,
      userId,
    );

    return pageResult;
  }

  Future<PaginatedList<UserJourney>> refreshUserJourneys(
    int userJourneysPerPage,
    int userId,
  ) async {
    final pageResult = await userJourneyApi.getUserJourneys(
      0,
      userJourneysPerPage,
      userId,
    );

    return pageResult;
  }

  Future<List<int>> getUserJourneyFile(int userJourneyId) {
    return userJourneyApi.getUserJourneyFile(userJourneyId);
  }

  Future<void> deleteUserJourney(int userJourneyId) {
    return userJourneyApi.deleteUserJourney(userJourneyId);
  }
}
