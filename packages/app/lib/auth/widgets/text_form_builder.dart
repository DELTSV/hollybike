import 'package:flutter/material.dart';
import 'package:hollybike/auth/widgets/control_text_form_field.dart';
import 'package:hollybike/auth/widgets/secured_text_form_field.dart';

import '../types/form_field_config.dart';

class TextFormBuilder extends StatefulWidget {
  final void Function(Map<String, String>) onFormSubmit;
  final FormFields formFields;

  const TextFormBuilder({
    super.key,
    required this.onFormSubmit,
    required this.formFields,
  });

  @override
  State<TextFormBuilder> createState() => _TextFormBuilderState();
}

class _TextFormBuilderState extends State<TextFormBuilder> {
  final _formKey = GlobalKey<FormState>();

  late Map<String, TextEditingController> _formControllers;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: _convertFormFieldsToWidgets(widget.formFields) +
            [
              ElevatedButton(
                onPressed: _handleFormSubmit,
                child: const Text("submit"),
              ),
            ],
      ),
    );
  }

  List<Widget> _convertFormFieldsToWidgets(FormFields formFields) {
    _formControllers = Map.fromIterables(
      formFields.keys,
      formFields.values.map((_) => TextEditingController()),
    );

    return formFields.entries
        .map<Widget>(
          (field) => _convertFieldToWidget(field.key, field.value),
        )
        .toList();
  }

  Widget _convertFieldToWidget(String key, FormFieldConfig config) {
    final decoration = InputDecoration(labelText: key);
    final controller = _formControllers[key];

    if (config.isSecured == false) {
      return TextFormField(
        validator: config.validator,
        controller: controller,
        decoration: decoration,
      );
    }

    var fields = <Widget>[
      SecuredTextFormField(
        controller: controller,
        decoration: decoration,
        validator: config.validator,
      )
    ];

    if (config.hasControlField) {
      fields.add(ControlTextFormField(
        controlledFieldText: key,
        controller: controller,
      ));
    }

    return Column(children: fields);
  }

  void _handleFormSubmit() {
    if (_formKey.currentState!.validate()) {
      final data = Map.fromIterables(_formControllers.keys,
          _formControllers.values.map((controller) => controller.text));
      widget.onFormSubmit(data);
    }
  }
}
