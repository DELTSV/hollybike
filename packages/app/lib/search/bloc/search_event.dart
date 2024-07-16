/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

@immutable
abstract class SearchEvent {}

class SubscribeToEventsSearch extends SearchEvent {
  SubscribeToEventsSearch();
}

class LoadEventsSearchNextPage extends SearchEvent {
  LoadEventsSearchNextPage();
}

class LoadProfilesSearchNextPage extends SearchEvent {
  LoadProfilesSearchNextPage();
}

class RefreshSearch extends SearchEvent {
  final String query;

  RefreshSearch({required this.query});
}
