import 'package:flutter/cupertino.dart';

@immutable
abstract class UserJourneyDetailsEvent {}

class DeleteUserJourney extends UserJourneyDetailsEvent {
  DeleteUserJourney();
}

class DownloadUserJourney extends UserJourneyDetailsEvent {
  DownloadUserJourney();
}
