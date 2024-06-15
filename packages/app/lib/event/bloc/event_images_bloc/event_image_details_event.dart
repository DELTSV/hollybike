import 'package:flutter/cupertino.dart';

import '../../../auth/types/auth_session.dart';

@immutable
abstract class EventImageDetailsEvent {}

class GetEventImageDetails extends EventImageDetailsEvent {
  final AuthSession session;
  final int imageId;

  GetEventImageDetails({
    required this.session,
    required this.imageId,
  });
}

class DeleteImage extends EventImageDetailsEvent {
  final AuthSession session;
  final int imageId;

  DeleteImage({
    required this.session,
    required this.imageId,
  });
}