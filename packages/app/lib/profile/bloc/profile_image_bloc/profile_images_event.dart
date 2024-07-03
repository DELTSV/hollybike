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
  final bool initial;

  RefreshProfileImages({
    required this.userId,
    this.initial = false,
  });
}