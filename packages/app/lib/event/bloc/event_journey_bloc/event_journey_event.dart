import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../auth/types/auth_session.dart';

@immutable
abstract class EventJourneyEvent {}

class UploadJourneyFileToEvent extends EventJourneyEvent {
  final AuthSession session;
  final int eventId;
  final String name;
  final File file;

  UploadJourneyFileToEvent({
    required this.session,
    required this.eventId,
    required this.name,
    required this.file,
  });
}