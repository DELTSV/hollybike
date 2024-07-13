import 'package:flutter/material.dart';
import 'package:hollybike/auth/types/field_editing_controller.dart';
import 'package:hollybike/auth/types/field_focus_node.dart';
import 'package:hollybike/auth/types/form_texts.dart';
import 'package:hollybike/shared/widgets/text_field/common_text_field.dart';
import 'package:hollybike/shared/widgets/text_field/control_text_form_field.dart';
import 'package:hollybike/shared/widgets/text_field/secured_text_field.dart';

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
  late final GlobalKey<FormState> _formKey;
  late final Map<String, FieldFocusNode> _formFocusNodes;
  late final Map<String, FieldEditingController> _formControllers;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _formControllers = Map.fromIterables(
      widget.formFields.keys,
      widget.formFields.values.map(
        (field) => FieldEditingController(
          hasControlNode: field.isSecured && field.hasControlField,
          defaultValue: field.defaultValue,
        ),
      ),
    );
    _formFocusNodes = Map.fromIterables(
      widget.formFields.keys,
      widget.formFields.values.map<FieldFocusNode>(
        (config) => FieldFocusNode(
          hasControlNode: config.isSecured && config.hasControlField,
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        runSpacing: 24,
        children: _convertFormFieldsToWidgets(widget.formFields) +
            _getFormFooter(widget.texts),
      ),
    );
  }

  List<Widget> _getFormFooter(FormTexts texts) {
    final button = Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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

    final linkDescription = FormTexts.toWidgetArray(
      texts.link!.description,
      style: Theme.of(context).textTheme.bodyMedium,
    );
    final linkButton = <Widget>[
      GestureDetector(
        onTap: texts.link!.onDestinationClick,
        child: Text(
          texts.link!.buttonText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    return formFields.entries.expand<Widget>(_convertFieldToWidget).toList();
  }

  List<Widget> _convertFieldToWidget(MapEntry<String, FormFieldConfig> field) {
    final MapEntry<String, FormFieldConfig>(:key, value: config) = field;
    final focusNode = _formFocusNodes[key];
    final controller = _formControllers[key];

    next() {
      final nextKey = getNextKey(key);

      if (nextKey == null) {
        _handleFormSubmit();
        return;
      }

      final nextNode = _formFocusNodes[nextKey];
      nextNode?.focusNode.requestFocus();
    }

    if (config.isSecured == false) {
      return <Widget>[
        CommonTextField(
          validator: config.validator,
          title: config.label,
          controller: controller?.editingController,
          focusNode: focusNode?.focusNode,
          onEditingDone: next,
          autofocus: config.autofocus,
          autofillHints: config.autofillHints,
          textInputType: config.textInputType,
        )
      ];
    }

    var fields = <Widget>[
      SecuredTextField(
        controller: controller?.editingController,
        title: config.label,
        validator: config.validator,
        focusNode: focusNode?.focusNode,
        onEditingDone: config.hasControlField
            ? () => focusNode?.controlFocusNode?.requestFocus()
            : next,
        autofocus: config.autofocus,
        autofillHints: config.autofillHints,
        textInputType: config.textInputType,
      ),
    ];

    if (config.hasControlField) {
      fields.add(ControlTextField(
        controller: controller?.controlEditingController,
        controlledFieldTitle: config.label,
        focusNode: focusNode?.controlFocusNode,
        onEditingDone: next,
        textInputType: config.textInputType,
      ));
    }

    return fields;
  }

  String? getNextKey(String key) {
    for (int i = 0; i < widget.formFields.length - 1; i++) {
      if (widget.formFields.keys.elementAt(i) == key) {
        return widget.formFields.keys.elementAt(i + 1);
      }
    }
    return null;
  }

  void _handleFormSubmit() {
    if (_formKey.currentState!.validate()) {
      final data = Map.fromIterables(
        _formControllers.keys,
        _formControllers.values
            .map((controller) => controller.editingController.text),
      );
      widget.onFormSubmit(data);
    }
  }
}
