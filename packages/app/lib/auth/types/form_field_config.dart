/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/cupertino.dart';

typedef FormFields = Map<String, FormFieldConfig>;

class FormFieldConfig {
  final String label;
  final String? Function(String?) validator;
  final String? defaultValue;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final TextInputType? textInputType;

  final bool isSecured;
  final bool hasControlField;

  FormFieldConfig({
    required this.label,
    required this.validator,
    this.defaultValue,
    this.autofocus = false,
    this.autofillHints,
    this.textInputType,
    this.isSecured = false,
    this.hasControlField = false,
  });
}
