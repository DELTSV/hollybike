/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/cupertino.dart';

@immutable
abstract class ProfileImagesEvent {}

class LoadProfileImagesNextPage extends ProfileImagesEvent {
  LoadProfileImagesNextPage();
}

class RefreshProfileImages extends ProfileImagesEvent {
  RefreshProfileImages();
}
