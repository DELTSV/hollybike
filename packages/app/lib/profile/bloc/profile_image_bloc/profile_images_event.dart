import 'package:flutter/cupertino.dart';

@immutable
abstract class ProfileImagesEvent {}

class LoadProfileImagesNextPage extends ProfileImagesEvent {
  final int userId;

  LoadProfileImagesNextPage({
    required this.userId,
  });
}

class RefreshProfileImages extends ProfileImagesEvent {
  final int userId;

  RefreshProfileImages({
    required this.userId,
  });
}