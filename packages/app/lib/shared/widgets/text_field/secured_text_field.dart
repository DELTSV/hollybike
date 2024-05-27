import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/text_field/common_text_field.dart';

class SecuredTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String title;
  final String? Function(String?) validator;
  final FocusNode? focusNode;
  final void Function()? onEditingDone;

  const SecuredTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.validator,
    this.focusNode,
    this.onEditingDone,
  });

  @override
  State<SecuredTextField> createState() => _SecuredTextFieldState();
}

class _SecuredTextFieldState extends State<SecuredTextField> {
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      controller: widget.controller,
      title: widget.title,
      validator: widget.validator,
      obscureText: _hide,
      focusNode: widget.focusNode,
      onEditingDone: widget.onEditingDone,
      iconButton: IconButton(
        onPressed: () => setState(() {
          _hide = !_hide;
        }),
        icon: Icon(
          _hide ? Icons.visibility_off : Icons.visibility,
        ),
      ),
    );
  }
}
