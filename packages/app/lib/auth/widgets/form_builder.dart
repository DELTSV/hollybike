import 'package:flutter/material.dart';
import 'package:hollybike/notification/widgets/error_consumer.dart';
import 'package:hollybike/shared/widgets/form_title.dart';

import '../types/form_field_config.dart';
import '../types/form_texts.dart';
import 'text_form_builder.dart';

class FormBuilder extends StatefulWidget {
  final String title;
  final String? description;
  final String notificationsConsumerId;
  final FormTexts formTexts;
  final void Function(Map<String, String>) onFormSubmit;
  final Map<String, FormFieldConfig> formFields;

  const FormBuilder({
    super.key,
    required this.title,
    required this.description,
    required this.notificationsConsumerId,
    required this.formTexts,
    required this.onFormSubmit,
    required this.formFields,
  });

  @override
  State<FormBuilder> createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final height = MediaQuery.of(context).size.height;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: height < 500 ? height-150 : 500),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Wrap(
                runSpacing: 24,
                children:
                    _renderHeader() + _renderError() + _renderTextInputs(),
              ),
            ),
          ),
        );
      },
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
      ErrorConsumer(notificationsConsumerId: widget.notificationsConsumerId,),
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
