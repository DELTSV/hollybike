/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/cupertino.dart';

@immutable
abstract class EventImagesEvent {}

class LoadEventImagesNextPage extends EventImagesEvent {
  LoadEventImagesNextPage();
}

class RefreshEventImages extends EventImagesEvent {
  RefreshEventImages();
}
