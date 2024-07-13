import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/text_field/secured_text_field.dart';

class ControlTextField extends StatelessWidget {
  final String controlledFieldTitle;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function()? onEditingDone;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final TextInputType? textInputType;

  const ControlTextField({
    super.key,
    required this.controlledFieldTitle,
    required this.controller,
    this.focusNode,
    this.onEditingDone,
    this.autofocus = false,
    this.autofillHints,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return SecuredTextField(
      controller: controller,
      title: "Confirmer le $controlledFieldTitle",
      validator: _confirmFieldValidator,
      focusNode: focusNode,
      onEditingDone: onEditingDone,
      autofocus: autofocus,
      autofillHints: autofillHints,
      textInputType: textInputType,
    );
  }

  String? _confirmFieldValidator(String? value) {
    if (value == null || value.isEmpty || value != controller!.text) {
      return "Ce champ devrait avoir la même valeur que $controlledFieldTitle";
    }
    return null;
  }
}
