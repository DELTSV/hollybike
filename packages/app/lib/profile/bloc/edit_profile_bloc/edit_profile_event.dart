import 'dart:io';

import 'package:flutter/foundation.dart';

@immutable
abstract class EditProfileEvent {}

class SaveProfileChanges extends EditProfileEvent {
  final String username;
  final String? description;

  final File? image;

  SaveProfileChanges({
    required this.username,
    this.description,
    this.image,
  });
}

class ChangeProfilePassword extends EditProfileEvent {
  final String oldPassword;
  final String newPassword;

  ChangeProfilePassword({
    required this.oldPassword,
    required this.newPassword,
  });
}

class ResetPassword extends EditProfileEvent {
  final String email;
  final String? host;

  ResetPassword({
    required this.email,
    this.host,
  });
}