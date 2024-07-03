import 'dart:io';

import 'package:flutter/cupertino.dart';

@immutable
abstract class EventMyImagesEvent {}

class LoadMyEventImagesNextPage extends EventMyImagesEvent {
  LoadMyEventImagesNextPage();
}

class RefreshMyEventImages extends EventMyImagesEvent {
  RefreshMyEventImages();
}

class UploadEventImages extends EventMyImagesEvent {
  final List<File> images;

  UploadEventImages({
    required this.images,
  });
}

class UpdateImagesVisibility extends EventMyImagesEvent {
  final bool isPublic;

  UpdateImagesVisibility({
    required this.isPublic,
  });
}
