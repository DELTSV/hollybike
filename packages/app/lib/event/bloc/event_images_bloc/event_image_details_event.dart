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
