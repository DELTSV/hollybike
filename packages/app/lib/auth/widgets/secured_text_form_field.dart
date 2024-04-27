import 'package:flutter/material.dart';

class SecuredTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final InputDecoration decoration;
  final String? Function(String?) validator;

  const SecuredTextFormField({
    super.key,
    required this.controller,
    required this.decoration,
    required this.validator,
  });

  @override
  State<SecuredTextFormField> createState() => _SecuredTextFormFieldState();
}

class _SecuredTextFormFieldState extends State<SecuredTextFormField> {
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
            validator: widget.validator,
            controller: widget.controller,
            obscureText: _hide,
            decoration: widget.decoration,
          ),
        ),
      ],
    );
  }
}
