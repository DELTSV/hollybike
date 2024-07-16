/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final String? Function(String?)? validator;
  final bool obscureText;
  final IconButton? iconButton;
  final FocusNode? focusNode;
  final void Function()? onEditingDone;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final TextInputType? textInputType;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.title,
    this.validator,
    this.obscureText = false,
    this.iconButton,
    this.focusNode,
    this.onEditingDone,
    this.autofocus = false,
    this.autofillHints,
    this.textInputType,
    this.autovalidateMode,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      labelText: title,
      fillColor: Theme.of(context).colorScheme.primaryContainer,
      filled: true,
      suffixIcon: iconButton,
    );

    return Material(
      color: Colors.transparent,
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        decoration: decoration,
        autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
        autofocus: autofocus,
        autofillHints: autofillHints,
        keyboardType: textInputType,
        focusNode: focusNode,
        inputFormatters: inputFormatters,
        onEditingComplete: onEditingDone,
        textCapitalization: textCapitalization,
      ),
    );
  }
}
