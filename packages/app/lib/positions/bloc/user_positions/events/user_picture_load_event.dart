/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
part of '../user_positions_bloc.dart';

abstract class UserPictureLoadEvent extends UserPositionsEvent {
  final String picturePath;

  const UserPictureLoadEvent({required this.picturePath});

  @override
  bool operator ==(covariant UserPictureLoadEvent other) {
    return picturePath == other.picturePath;
  }

  @override
  int get hashCode => Object.hash(picturePath, super.hashCode);
}

class UserPictureLoadingEvent extends UserPictureLoadEvent {
  const UserPictureLoadingEvent({required super.picturePath});
}

class UserPictureLoadSuccessEvent extends UserPictureLoadEvent {
  final List<int> image;

  const UserPictureLoadSuccessEvent({
    required super.picturePath,
    required this.image,
  });
}

class UserPictureLoadErrorEvent extends UserPictureLoadEvent {
  final Error error;

  const UserPictureLoadErrorEvent({
    required super.picturePath,
    required this.error,
  });
}
