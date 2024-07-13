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
