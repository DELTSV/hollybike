/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/cupertino.dart';

@immutable
abstract class JourneysLibraryEvent {}

class LoadJourneysLibraryNextPage extends JourneysLibraryEvent {
  LoadJourneysLibraryNextPage();
}

class RefreshJourneysLibrary extends JourneysLibraryEvent {
  RefreshJourneysLibrary();
}
