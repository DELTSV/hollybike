import 'package:flutter/cupertino.dart';

@immutable
abstract class EventImageDetailsEvent {}

class GetEventImageDetails extends EventImageDetailsEvent {
  final int imageId;

  GetEventImageDetails({
    required this.imageId,
  });
}

class DeleteImage extends EventImageDetailsEvent {
  final int imageId;

  DeleteImage({
    required this.imageId,
  });
}

class DownloadImage extends EventImageDetailsEvent {
  final String imageUrl;
  final int imgId;

  DownloadImage({
    required this.imageUrl,
    required this.imgId,
  });
}
