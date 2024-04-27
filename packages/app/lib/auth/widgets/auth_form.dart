import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hollybike/auth/widgets/password_form_field.dart';

typedef FormFields = Map<String, FormFieldConfig>;
typedef FormFieldConfig = ({
  String? Function(String?) validator,
  bool isHideable
});

class AuthForm extends StatefulWidget {
  final void Function(Map<String, String>) onFormSubmit;
  final FormFields formFields;

  const AuthForm({
    super.key,
    required this.onFormSubmit,
    required this.formFields,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
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

    if (config.isHideable == false) {
      return TextFormField(
        validator: config.validator,
        controller: controller,
        decoration: decoration,
      );
    }

    return PasswordFormField(
      controller: controller,
      decoration: decoration,
      validator: config.validator,
    );
  }

  void _handleFormSubmit() {
    if (_formKey.currentState!.validate()) {
      final data = Map.fromIterables(_formControllers.keys,
          _formControllers.values.map((controller) => controller.text));
      widget.onFormSubmit(data);
    }
  }
}
