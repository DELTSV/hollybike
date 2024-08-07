/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class FieldEditingController {
  final TextEditingController editingController;
  final TextEditingController? controlEditingController;

  FieldEditingController({
    bool? hasControlNode = false,
    String? defaultValue,
  })  : editingController = TextEditingController(text: defaultValue),
        controlEditingController = hasControlNode == true
            ? TextEditingController(text: defaultValue)
            : null;
}
