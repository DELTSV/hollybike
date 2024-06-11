import 'dart:io';

import 'package:hollybike/images/types/event_image.dart';

import '../../auth/types/auth_session.dart';
import '../../shared/types/paginated_list.dart';
import 'image_api.dart';

class ImageRepository {
  final ImageApi imageApi;

  ImageRepository({required this.imageApi});

  Future<PaginatedList<EventImage>> fetchEventImages(
    AuthSession session,
    int eventId,
    int page,
    int eventsPerPage,
  ) async {
    final pageResult =
        await imageApi.getEventImages(session, eventId, page, eventsPerPage);

    return pageResult;
  }

  Future<PaginatedList<EventImage>> refreshEventImages(
    AuthSession session,
    int eventId,
    int eventsPerPage,
  ) async {
    final pageResult =
        await imageApi.getEventImages(session, eventId, 0, eventsPerPage);

    return pageResult;
  }

  Future<void> uploadEventImages(
    AuthSession session,
    int eventId,
    List<File> images,
  ) async {
    await imageApi.uploadEventImages(session, eventId, images);
  }
}
