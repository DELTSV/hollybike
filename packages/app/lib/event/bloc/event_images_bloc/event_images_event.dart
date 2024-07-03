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
  final bool initial;

  RefreshEventImages({
    required this.eventId,
    this.initial = false,
  });
}
