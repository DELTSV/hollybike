import 'package:flutter/cupertino.dart';

@immutable
abstract class EventImagesEvent {}

class LoadEventImagesNextPage extends EventImagesEvent {
  final int eventId;

  LoadEventImagesNextPage({
    required this.eventId,
  });
}

class RefreshEventImages extends EventImagesEvent {
  final int eventId;

  RefreshEventImages({
    required this.eventId,
  });
}
