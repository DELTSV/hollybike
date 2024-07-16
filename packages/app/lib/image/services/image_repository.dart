/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:hollybike/image/type/event_image.dart';
import 'package:hollybike/image/type/event_image_details.dart';

import '../../../image/services/image_api.dart';
import '../../../shared/types/paginated_list.dart';

class ImageRepository {
  final ImageApi imageApi;

  ImageRepository({required this.imageApi});

  Future<PaginatedList<EventImage>> fetchEventImages(
    int eventId,
    int page,
    int eventsPerPage,
  ) async {
    final pageResult = await imageApi.getEventImages(
      eventId,
      page,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<PaginatedList<EventImage>> refreshEventImages(
    int eventId,
    int eventsPerPage,
  ) async {
    final pageResult = await imageApi.getEventImages(
      eventId,
      0,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<PaginatedList<EventImage>> fetchMyEventImages(
    int eventId,
    int page,
    int eventsPerPage,
  ) async {
    final pageResult = await imageApi.getMyEventImages(
      eventId,
      page,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<PaginatedList<EventImage>> refreshMyEventImages(
    int eventId,
    int eventsPerPage,
  ) async {
    final pageResult = await imageApi.getMyEventImages(
      eventId,
      0,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<PaginatedList<EventImage>> fetchProfileImages(
    int userId,
    int page,
    int eventsPerPage,
  ) async {
    final pageResult = await imageApi.getProfileImages(
      userId,
      page,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<PaginatedList<EventImage>> refreshProfileImages(
    int userId,
    int eventsPerPage,
  ) async {
    final pageResult = await imageApi.getProfileImages(
      userId,
      0,
      eventsPerPage,
    );

    return pageResult;
  }

  Future<void> uploadEventImages(
    int eventId,
    List<File> images,
  ) async {
    await imageApi.uploadEventImages(eventId, images);
  }

  Future<void> updateImagesVisibility(
    int eventId,
    bool isPublic,
  ) async {
    await imageApi.updateImagesVisibility(eventId, isPublic);
  }

  Future<EventImageDetails> getImageDetails(
    int imageId,
  ) async {
    final imageDetails = await imageApi.getImageDetails(
      imageId,
    );

    return imageDetails;
  }

  Future<void> deleteImage(
    int imageId,
  ) async {
    await imageApi.deleteImage(
      imageId,
    );
  }

  Future<void> downloadImage(
    String imageUrl,
    int imgId,
  ) async {
    await imageApi.downloadImage(
      imageUrl,
      imgId,
    );
  }
}
