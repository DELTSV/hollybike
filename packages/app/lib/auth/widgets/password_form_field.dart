import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController? controller;
  final InputDecoration decoration;
  final String? Function(String?) validator;

  const PasswordFormField({
    super.key,
    required this.controller,
    required this.decoration,
    required this.validator,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormField(
            validator: widget.validator,
            controller: widget.controller,
            obscureText: _hide,
            decoration: widget.decoration,
          ),
        ),
        IconButton(
          onPressed: () => setState(() {
            _hide = !_hide;
          }),
          icon: Icon(
            _hide ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ],
    );
  }
}
