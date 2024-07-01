import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../journey/type/journey.dart';

@immutable
abstract class EventJourneyEvent {}

class UploadJourneyFileToEvent extends EventJourneyEvent {
  final int eventId;
  final String name;
  final File file;

  UploadJourneyFileToEvent({
    required this.eventId,
    required this.name,
    required this.file,
  });
}

class AttachJourneyToEvent extends EventJourneyEvent {
  final int eventId;
  final Journey journey;

  AttachJourneyToEvent({
    required this.eventId,
    required this.journey,
  });
}

class RemoveJourneyFromEvent extends EventJourneyEvent {
  final int eventId;

  RemoveJourneyFromEvent({
    required this.eventId,
  });
}
