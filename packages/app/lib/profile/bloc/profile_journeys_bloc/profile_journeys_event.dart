import 'package:flutter/cupertino.dart';

@immutable
abstract class ProfileJourneysEvent {}

class LoadProfileJourneysNextPage extends ProfileJourneysEvent {
  LoadProfileJourneysNextPage();
}

class RefreshProfileJourneys extends ProfileJourneysEvent {
  RefreshProfileJourneys();
}
