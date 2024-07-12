import 'package:hollybike/shared/http/dio_client.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:hollybike/shared/http/downloader.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';

class UserJourneyApi {
  final DioClient client;
  final Downloader downloader;

  UserJourneyApi({required this.client, required this.downloader});

  Future<PaginatedList<UserJourney>> getUserJourneys(
    int page,
    int userJourneysPerPage,
    int userId,
  ) async {
    final response = await client.dio.get(
      '/user-journeys/user/$userId',
      queryParameters: {
        'page': page,
        'per_page': userJourneysPerPage,
        'sort': 'created_at.desc'
      },
    );

    return PaginatedList.fromJson(response.data, UserJourney.fromJson);
  }

  Future<void> downloadUserJourneyFile(int userJourneyId, String fileName) async {
    await downloader.downloadFile(
      '/user-journeys/$userJourneyId/file',
      fileName,
      authenticate: true,
      extraHeaders: {
        'Accept': 'gpx',
      },
    );
  }

  Future<void> deleteUserJourney(int userJourneyId) async {
    await client.dio.delete(
      '/user-journeys/$userJourneyId',
    );
  }
}
