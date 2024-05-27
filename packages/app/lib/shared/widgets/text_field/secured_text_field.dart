import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/text_field/common_text_field.dart';

class SecuredTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String title;
  final String? Function(String?) validator;
  final FocusNode? focusNode;
  final void Function()? onEditingDone;
  final bool autofocus;
  final Iterable<String>? autofillHints;
  final TextInputType? textInputType;

  const SecuredTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.validator,
    this.focusNode,
    this.onEditingDone,
    this.autofocus = false,
    this.autofillHints,
    this.textInputType,
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
      autofocus: widget.autofocus,
      autofillHints: widget.autofillHints,
      textInputType: widget.textInputType,
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
