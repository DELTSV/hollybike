/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/cupertino.dart';

@immutable
abstract class ProfileJourneysEvent {}

class LoadProfileJourneysNextPage extends ProfileJourneysEvent {
  LoadProfileJourneysNextPage();
}

class RefreshProfileJourneys extends ProfileJourneysEvent {
  RefreshProfileJourneys();
}
