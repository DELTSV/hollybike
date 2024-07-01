import 'dart:io';

import 'package:flutter/cupertino.dart';


@immutable
abstract class EventMyImagesEvent {}

class LoadMyEventImagesNextPage extends EventMyImagesEvent {
  final int eventId;

  LoadMyEventImagesNextPage({
    required this.eventId,
  });
}

class RefreshMyEventImages extends EventMyImagesEvent {
  final int eventId;

  RefreshMyEventImages({
    required this.eventId,
  });
}

class UploadEventImages extends EventMyImagesEvent {
  final int eventId;
  final List<File> images;

  UploadEventImages({
    required this.eventId,
    required this.images,
  });
}

class UpdateImagesVisibility extends EventMyImagesEvent {
  final int eventId;
  final bool isPublic;

  UpdateImagesVisibility({
    required this.eventId,
    required this.isPublic,
  });
}
