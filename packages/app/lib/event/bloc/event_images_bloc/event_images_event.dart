import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../auth/types/auth_session.dart';

@immutable
abstract class EventImagesEvent {}

class LoadEventImagesNextPage extends EventImagesEvent {
  final int eventId;
  final AuthSession session;

  LoadEventImagesNextPage({
    required this.session,
    required this.eventId,
  });
}

class RefreshEventImages extends EventImagesEvent {
  final int eventId;
  final AuthSession session;

  RefreshEventImages({
    required this.session,
    required this.eventId,
  });
}

class UploadEventImages extends EventImagesEvent {
  final int eventId;
  final AuthSession session;
  final List<File> images;

  UploadEventImages({
    required this.session,
    required this.eventId,
    required this.images,
  });
}