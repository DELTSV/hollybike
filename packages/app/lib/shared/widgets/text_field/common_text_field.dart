import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final String? Function(String?) validator;
  final bool obscureText;
  final IconButton? iconButton;
  final FocusNode? focusNode;
  final void Function()? onEditingDone;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.validator,
    this.obscureText = false,
    this.iconButton,
    this.focusNode,
    this.onEditingDone,
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

    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: decoration,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNode,
      onEditingComplete: onEditingDone,
    );
  }
}
