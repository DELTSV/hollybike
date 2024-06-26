import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

import '../../../shared/http/dio_client.dart';
import '../../../shared/types/paginated_list.dart';
import '../../types/image/event_image.dart';
import '../../types/image/event_image_details.dart';

class ImageApi {
  final DioClient client;

 ImageApi({required this.client});

  Future<PaginatedList<EventImage>> getEventImages(
    int eventId,
    int page,
    int imagesPerPage,
  ) async {
    final response = await client.dio.get(
      '/events/images',
      queryParameters: {
        'page': page,
        'per_page': imagesPerPage,
        'id_event': 'eq:$eventId',
        'sort': 'taken_date_time.desc'
      },
    );

    return PaginatedList.fromJson(response.data, EventImage.fromJson);
  }

  Future<PaginatedList<EventImage>> getMyEventImages(
    int eventId,
    int page,
    int imagesPerPage,
  ) async {
    final response = await client.dio.get(
      '/events/images/me',
      queryParameters: {
        'page': page,
        'per_page': imagesPerPage,
        'id_event': 'eq:$eventId',
        'sort': 'upload_date_time.desc'
      },
    );

    return PaginatedList.fromJson(response.data, EventImage.fromJson);
  }

  Future<void> uploadEventImages(
    int eventId,
    List<File> images,
  ) async {
    final imageParts = await Future.wait(images.map((image) async {
      final compressedImage = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 50,
        keepExif: true,
      );

      if (compressedImage == null) {
        throw Exception("Failed to compress image");
      }

      return MultipartFile.fromBytes(
        compressedImage,
        filename: image.path.split('/').last,
        contentType: MediaType.parse('image/jpeg'),
      );
    }).toList());

    final response = await client.dio.post(
          '/events/$eventId/images',
          data: FormData.fromMap(
            {'images': imageParts},
          ),
        );

    if (response.statusCode != 201) {
      throw Exception("Failed to upload event images");
    }
  }

  Future<void> updateImagesVisibility(
    int eventId,
    bool isPublic,
  ) async {
    final response = await client.dio.patch(
      '/events/$eventId/participations/images-visibility',
      data: {
        'is_images_public': isPublic,
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update images visibility");
    }
  }

  Future<EventImageDetails> getImageDetails(
    int imageId,
  ) async {
    final response = await client.dio.get(
          '/events/images/$imageId',
        );

    return EventImageDetails.fromJson(response.data);
  }

  Future<void> deleteImage(
    int imageId,
  ) async {
    final response = await client.dio.delete(
          '/events/images/$imageId',
        );

    if (response.statusCode != 204) {
      throw Exception("Failed to delete event image");
    }
  }
}
