import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/text_field/secured_text_field.dart';

class ControlTextField extends StatelessWidget {
  final String controlledFieldTitle;
  final TextEditingController? controller;

  const ControlTextField({
    super.key,
    required this.controlledFieldTitle,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SecuredTextField(
      controller: controller,
      title: "confirmer le $controlledFieldTitle",
      validator: _confirmFieldValidator,
    );
  }

  String? _confirmFieldValidator(String? value) {
    if (value == null || value.isEmpty || value != controller!.text) {
      return "Ce champ devrait avoir la même valeur que $controlledFieldTitle";
    }
    return null;
  }
}
