import 'package:flutter/material.dart';

class ControlTextFormField extends StatefulWidget {
  final String controlledFieldText;
  final TextEditingController? controller;

  const ControlTextFormField({
    super.key,
    required this.controlledFieldText,
    required this.controller,
  });

  @override
  State<ControlTextFormField> createState() => _ControlTextFormFieldState();
}

class _ControlTextFormFieldState extends State<ControlTextFormField> {
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => setState(() {
            _hide = !_hide;
          }),
          icon: Icon(
            _hide ? Icons.visibility_off : Icons.visibility,
          ),
        ),
        Expanded(
          child: TextFormField(
            validator: _confirmFieldValidator,
            obscureText: _hide,
            decoration: InputDecoration(
                labelText: "confirm ${widget.controlledFieldText}"),
          ),
        ),
      ],
    );
  }

  String? _confirmFieldValidator(String? value) {
    if (value == null || value.isEmpty || value != widget.controller!.text) {
      return "This input value should be equal to ${widget.controlledFieldText}";
    }
    return null;
  }
}
