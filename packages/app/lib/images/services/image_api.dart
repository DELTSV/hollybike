import '../../auth/types/auth_session.dart';
import '../../shared/http/dio_client.dart';
import '../../shared/types/paginated_list.dart';
import '../types/event_image.dart';

class ImageApi {
  Future<PaginatedList<EventImage>> getEventImages(
      AuthSession session,
      int eventId,
      int page,
      int imagesPerPage,
      ) async {
    final response = await DioClient(session).dio.get(
      '/events/future',
      queryParameters: {
        'page': page,
        'per_page': imagesPerPage,
        'id_event': 'eq:$eventId',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch event images");
    }

    return PaginatedList.fromJson(response.data, EventImage.fromJson);
  }
}