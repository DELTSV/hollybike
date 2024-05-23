import 'package:flutter/material.dart';

class SecuredTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?) validator;
  final InputDecoration Function({required IconButton iconButton})
      getDecoration;

  const SecuredTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    required this.getDecoration,
  });

  @override
  State<SecuredTextFormField> createState() => _SecuredTextFormFieldState();
}

class _SecuredTextFormFieldState extends State<SecuredTextFormField> {
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      obscureText: _hide,
      decoration: widget.getDecoration(
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
}
