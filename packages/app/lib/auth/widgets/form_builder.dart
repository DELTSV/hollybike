import 'package:flutter/material.dart';
import 'package:hollybike/auth/widgets/error_box.dart';
import 'package:hollybike/shared/utils/add_separators.dart';
import 'package:hollybike/shared/widgets/form_title.dart';

import '../types/form_field_config.dart';
import '../types/form_texts.dart';
import 'text_form_builder.dart';

class FormBuilder extends StatefulWidget {
  final String title;
  final String? description;
  final String? errorText;
  final FormTexts formTexts;
  final void Function(Map<String, String>) onFormSubmit;
  final Map<String, FormFieldConfig> formFields;

  const FormBuilder({
    super.key,
    required this.title,
    required this.description,
    required this.errorText,
    required this.formTexts,
    required this.onFormSubmit,
    required this.formFields,
  });

  @override
  State<FormBuilder> createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  late String? _errorText = widget.errorText;

  @override
  void didUpdateWidget(FormBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.errorText != _errorText) {
      setState(() {
        _errorText = widget.errorText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: addSeparators(
        _renderHeader() + _renderError() + _renderTextInputs(),
        const SizedBox(height: 16)
      ),
    );
  }

  List<Widget> _renderHeader() {
    return <Widget>[
      FormTitle(
        title: widget.title,
        description: widget.description,
      ),
    ];
  }

  List<Widget> _renderError() {
    return <Widget>[
      if (_errorText != null)
        ErrorBox(
          error: _errorText!,
          onCloseButtonClick: () {
            setState(() {
              _errorText = null;
            });
          },
        ),
    ];
  }

  List<Widget> _renderTextInputs() {
    return <Widget>[
      TextFormBuilder(
        texts: widget.formTexts,
        onFormSubmit: widget.onFormSubmit,
        formFields: widget.formFields,
      ),
    ];
  }
}
