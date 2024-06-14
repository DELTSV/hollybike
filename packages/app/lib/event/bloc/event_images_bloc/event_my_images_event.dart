import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../auth/types/auth_session.dart';

@immutable
abstract class EventMyImagesEvent {}

class LoadMyEventImagesNextPage extends EventMyImagesEvent {
  final int eventId;
  final AuthSession session;

  LoadMyEventImagesNextPage({
    required this.session,
    required this.eventId,
  });
}

class RefreshMyEventImages extends EventMyImagesEvent {
  final int eventId;
  final AuthSession session;

  RefreshMyEventImages({
    required this.session,
    required this.eventId,
  });
}

class UploadEventImages extends EventMyImagesEvent {
  final int eventId;
  final AuthSession session;
  final List<File> images;

  UploadEventImages({
    required this.session,
    required this.eventId,
    required this.images,
  });
}

class UpdateImagesVisibility extends EventMyImagesEvent {
  final int eventId;
  final AuthSession session;
  final bool isPublic;

  UpdateImagesVisibility({
    required this.session,
    required this.eventId,
    required this.isPublic,
  });
}