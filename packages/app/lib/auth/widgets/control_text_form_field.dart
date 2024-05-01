import 'package:flutter/material.dart';

class ControlTextFormField extends StatefulWidget {
  final String controlledFieldText;
  final TextEditingController? controller;
  final InputDecoration Function(String, {IconButton iconButton}) getDecoration;

  const ControlTextFormField({
    super.key,
    required this.controlledFieldText,
    required this.controller,
    required this.getDecoration,
  });

  @override
  State<ControlTextFormField> createState() => _ControlTextFormFieldState();
}

class _ControlTextFormFieldState extends State<ControlTextFormField> {
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: _confirmFieldValidator,
      obscureText: _hide,
      decoration: widget.getDecoration(
        "confirmer le ${widget.controlledFieldText}",
        iconButton: IconButton(
          onPressed: () => setState(() {
            _hide = !_hide;
          }),
          icon: Icon(
            _hide ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }

  String? _confirmFieldValidator(String? value) {
    if (value == null || value.isEmpty || value != widget.controller!.text) {
      return "Ce champ devrait avoir la même valeur que ${widget.controlledFieldText}";
    }
    return null;
  }
}
