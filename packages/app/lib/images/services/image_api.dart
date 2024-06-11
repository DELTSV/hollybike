import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';


import '../../auth/types/auth_session.dart';
import '../../shared/http/dio_client.dart';
import '../../shared/types/paginated_list.dart';
import '../types/event_image.dart';

class ImageApi {
  Future<PaginatedList<EventImage>> getEventImages(AuthSession session,
      int eventId,
      int page,
      int imagesPerPage,) async {
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

  MediaType? _getMediaTypeFormFile(File file) {
    final mimeType = lookupMimeType(file.path);

    if (mimeType == null) {
      return null;
    }

    return MediaType.parse(mimeType);
  }

  Future<void> uploadEventImages(AuthSession session,
      int eventId,
      List<File> images,) async {
    final imageParts = await Future.wait(
        images
            .map((image) async {
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
            filename: image.path
                .split('/')
                .last,
            contentType: _getMediaTypeFormFile(image),
          );
        })
            .toList()
    );

    final response = await DioClient(session).dio.post(
        '/events/$eventId/images',
        data: FormData.fromMap({
          'images': imageParts,
        })
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to upload event images");
    }
  }
}
