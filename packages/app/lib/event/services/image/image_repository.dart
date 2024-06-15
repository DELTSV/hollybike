import 'dart:io';

import 'package:hollybike/event/types/image/event_image.dart';

import '../../../auth/types/auth_session.dart';
import '../../../shared/types/paginated_list.dart';
import '../../types/image/event_image_details.dart';
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
    final pageResult = await imageApi.getEventImages(
      session,
      eventId,
      page,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<PaginatedList<EventImage>> refreshEventImages(
    AuthSession session,
    int eventId,
    int eventsPerPage,
  ) async {
    final pageResult = await imageApi.getEventImages(
      session,
      eventId,
      0,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<PaginatedList<EventImage>> fetchMyEventImages(
    AuthSession session,
    int eventId,
    int page,
    int eventsPerPage,
  ) async {
    final pageResult = await imageApi.getMyEventImages(
      session,
      eventId,
      page,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<PaginatedList<EventImage>> refreshMyEventImages(
    AuthSession session,
    int eventId,
    int eventsPerPage,
  ) async {
    final pageResult = await imageApi.getMyEventImages(
      session,
      eventId,
      0,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<void> uploadEventImages(
    AuthSession session,
    int eventId,
    List<File> images,
  ) async {
    await imageApi.uploadEventImages(session, eventId, images);
  }

  Future<void> updateImagesVisibility(
    AuthSession session,
    int eventId,
    bool isPublic,
  ) async {
    await imageApi.updateImagesVisibility(session, eventId, isPublic);
  }

  Future<EventImageDetails> getImageDetails(
    AuthSession session,
    int imageId,
  ) async {
    final imageDetails = await imageApi.getImageDetails(
      session,
      imageId,
    );

    return imageDetails;
  }

  Future<void> deleteImage(
    AuthSession session,
    int imageId,
  ) async {
    await imageApi.deleteImage(
      session,
      imageId,
    );
  }
}
