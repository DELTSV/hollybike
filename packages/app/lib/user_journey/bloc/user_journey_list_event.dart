import 'package:flutter/cupertino.dart';

@immutable
abstract class UserJourneyListEvent {}

class LoadUserJourneysNextPage extends UserJourneyListEvent {
  LoadUserJourneysNextPage();
}

class RefreshUserJourneysImages extends UserJourneyListEvent {
  RefreshUserJourneysImages();
}
