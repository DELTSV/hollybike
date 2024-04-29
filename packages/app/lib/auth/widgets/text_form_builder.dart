import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/types/form_texts.dart';
import 'package:hollybike/auth/widgets/control_text_form_field.dart';
import 'package:hollybike/auth/widgets/secured_text_form_field.dart';

import '../types/form_field_config.dart';

class TextFormBuilder extends StatefulWidget {
  final void Function(Map<String, String>) onFormSubmit;
  final FormFields formFields;
  final FormTexts texts;

  const TextFormBuilder({
    super.key,
    required this.onFormSubmit,
    required this.formFields,
    this.texts = const FormTexts(),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          runSpacing: 24,
          children: _getFormHeader(widget.texts) +
              _convertFormFieldsToWidgets(widget.formFields) +
              _getFormFooter(widget.texts),
        ),
      ),
    );
  }

  List<Widget> _getFormHeader(FormTexts texts) {
    final title = FormTexts.toWidgetArray(
      texts.title,
      style: Theme.of(context).textTheme.titleMedium,
    );
    final description = FormTexts.toWidgetArray(
      texts.description,
      style: Theme.of(context).textTheme.titleSmall,
    );

    return [
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        runSpacing: 2,
        children: title + description,
      )
    ];
  }

  List<Widget> _getFormFooter(FormTexts texts) {
    final button = Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.onPrimary),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            onPressed: _handleFormSubmit,
            child: Text(
              texts.submit ?? "Envoyer",
              style: const TextStyle(
                fontSize: 16,
                fontVariations: [FontVariation.weight(800)],
              ),
            ),
          ),
        ),
      ],
    );

    if (texts.link == null) {
      return <Widget>[button];
    }

    final linkDescription = FormTexts.toWidgetArray(texts.link!.description);
    final linkButton = <Widget>[
      GestureDetector(
        onTap: () => context.router.replace(texts.link!.destination),
        child: Text(
          texts.link!.buttonText,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      )
    ];

    return [
      Wrap(
        runSpacing: 8,
        children: [
          button,
          Wrap(
            direction: Axis.horizontal,
            spacing: 4,
            children: linkDescription + linkButton,
          ),
        ],
      ),
    ];
  }

  List<Widget> _convertFormFieldsToWidgets(FormFields formFields) {
    _formControllers = Map.fromIterables(
      formFields.keys,
      formFields.values.map((_) => TextEditingController()),
    );

    return formFields.entries
        .expand<Widget>(
            (field) => _convertFieldToWidget(field.key, field.value))
        .toList();
  }

  List<Widget> _convertFieldToWidget(String key, FormFieldConfig config) {
    final decoration = _getInputDecoration(config.label);
    final controller = _formControllers[key];

    if (config.isSecured == false) {
      return <Widget>[
        TextFormField(
          validator: config.validator,
          controller: controller,
          decoration: decoration,
        )
      ];
    }

    var fields = <Widget>[
      SecuredTextFormField(
        controller: controller,
        getDecoration: ({required IconButton iconButton}) =>
            _getInputDecoration(
          config.label,
          iconButton: iconButton,
        ),
        validator: config.validator,
      ),
    ];

    if (config.hasControlField) {
      fields.add(ControlTextFormField(
        controlledFieldText: config.label,
        controller: controller,
        getDecoration: _getInputDecoration,
      ));
    }

    return fields;
  }

  InputDecoration _getInputDecoration(String labelText,
      {IconButton? iconButton}) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      labelText: labelText,
      fillColor: Theme.of(context).colorScheme.primaryContainer,
      filled: true,
      suffixIcon: iconButton,
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
