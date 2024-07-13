import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hollybike/shared/widgets/text_field/common_text_field.dart';
import 'package:intl/intl.dart';

class CurrencyInput extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String labelText;

  const CurrencyInput({
    super.key,
    required this.controller,
    this.validator,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      controller: controller,
      title: labelText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CurrencyInputFormatter(),
      ],
      validator: validator,
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  static String defaultFormat(String text) {
    return _format(text);
  }

  static String _format(String text) {
    String numericText = text.replaceAll(RegExp(r'[^0-9]'), '');

    double value = double.parse(numericText);

    final formatter = NumberFormat.simpleCurrency(locale: "fr_FR");
    String newText = formatter.format(value / 100);
    return newText;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = _format(newValue.text);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length - 2),
    );
  }
}
